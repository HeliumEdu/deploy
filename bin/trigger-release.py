#!/usr/bin/env python

__copyright__ = "Copyright (c) 2025 Helium Edu"
__license__ = "MIT"

import json
import os
import re
import sys
import time
from urllib import request, parse
from urllib.request import urlopen

import boto3
from git import Repo
from heliumcli import utils
from heliumcli.actions.buildrelease import BuildReleaseAction
from heliumcli.utils import get_config

BASE_DIR = os.path.normpath(os.path.join(os.path.abspath(os.path.dirname(__file__)), '..'))

VERSION = os.environ.get("VERSION")
ENVIRONMENT = os.environ.get("ENVIRONMENT")
TERRAFORM_API_TOKEN = os.environ.get("TERRAFORM_API_TOKEN")
FRONTEND_ROLLBAR_SERVER_ITEM_ACCESS_TOKEN = os.environ.get("FRONTEND_ROLLBAR_SERVER_ITEM_ACCESS_TOKEN")
CUT_RELEASE = os.environ.get("CUT_RELEASE", "true") == "true"

if not VERSION or not ENVIRONMENT or not TERRAFORM_API_TOKEN or not FRONTEND_ROLLBAR_SERVER_ITEM_ACCESS_TOKEN or \
        not os.environ.get("AWS_ACCOUNT_ID") or not os.environ.get("AWS_ACCESS_KEY_ID") or not os.environ.get(
    "AWS_SECRET_ACCESS_KEY"):
    print(
        "ERROR: Set all required env vars: VERSION, ENVIRONMENT, TERRAFORM_API_TOKEN, FRONTEND_ROLLBAR_SERVER_ITEM_ACCESS_TOKEN, AWS_ACCOUNT_ID, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY.")
    sys.exit(1)

INFO_URI = "https://{}.heliumedu.com/info".format("api" if ENVIRONMENT == "prod" else f"api.{ENVIRONMENT}")

FILE_PATH = os.path.join(BASE_DIR, "terraform", "environments", ENVIRONMENT, "variables.tf")
VERSION_VARIABLE_PATTERN = """variable "helium_version" {{
  description = "The container version. Bumping this will trigger a deploy."
  default     = "{version}"
}}"""
VERSION_VARIABLE_REGEX = VERSION_VARIABLE_PATTERN.format(version="(\\d+.\\d+.\\d+)")

#####################################################################
# Bump release version and commit to prep for release deployment
#####################################################################

if not CUT_RELEASE:
    print("CUT_RELEASE is set to 'false'. Deploying old release means no changes committed, and VERSION will be used"
          "to set Terraform's 'helium_version' as an override parameter.")
else:
    with open(FILE_PATH, "r") as fp:
        file_contents = fp.read()

    match = re.match(VERSION_VARIABLE_REGEX, file_contents)
    if match:
        result = re.sub(VERSION_VARIABLE_REGEX, VERSION_VARIABLE_PATTERN.format(version=VERSION), file_contents)

        if file_contents != result:
            with open(FILE_PATH, "w") as fp:
                fp.write(result)
    else:
        print(
            "ERROR: variables.tf does not appear to be in the expected format. Ensure the \"helium_version\" variable is "
            "defined, with a default, and is the first declaration in the file.")
        sys.exit(1)

    repo = Repo(BASE_DIR)
    if not repo.is_dirty() or VERSION in repo.tags:
        print("ERROR: No changes detected or version already exists. Terraform won't trigger the release. "
              "Set CUT_RELEASE=false if attempting to deploy a previous build.")
        sys.exit(1)
    else:
        config = get_config()

        build_release_action = BuildReleaseAction()
        print(f"Committing changes and creating release tag {VERSION} ...")
        print(utils.get_repo_name(BASE_DIR, config["remoteName"]))
        build_release_action._commit_and_tag(BASE_DIR, VERSION, config["remoteName"], config["branchName"])

        print(f"... release version {VERSION} committed.")

#####################################################################
# Fetch Terraform Workspace details
#####################################################################

req = request.Request(f"https://app.terraform.io/api/v2/organizations/HeliumEdu/workspaces/{ENVIRONMENT}",
                      headers={"Authorization": f"Bearer {TERRAFORM_API_TOKEN}",
                               "Content-Type": "application/vnd.api+json"})
workspaces_response = json.loads(urlopen(req).read())

#####################################################################
# Find planned [heliumcli] Terraform run, discard other pending
#####################################################################

if not CUT_RELEASE:
    req = request.Request(f"https://app.terraform.io/api/v2/runs",
                          headers={"Authorization": f"Bearer {TERRAFORM_API_TOKEN}",
                                   "Content-Type": "application/vnd.api+json"},
                          data=json.dumps({"data":
                              {"attributes": {
                                  "message": f"[heliumcli] Deploy {VERSION}",
                                  "allow-empty-apply": "true",
                                  "auto-apply": "false",
                                  "variables": [
                                      {"key": "helium_version", "value": f"\"{VERSION}\""}
                                  ]
                              }, "relationships": {
                                  "workspace": {
                                      "data": {
                                          "id": workspaces_response["data"]["id"],
                                          "type": "workspaces"
                                      }
                                  }
                              }}}).encode())
    resp = urlopen(req)

heliumcli_run = None
retries = 0
retry_sleep_seconds = 10
wait_minutes = 3
while retries < ((wait_minutes * 60) / retry_sleep_seconds):
    req = request.Request(f"https://app.terraform.io/api/v2/workspaces/{workspaces_response['data']['id']}/runs",
                          headers={"Authorization": f"Bearer {TERRAFORM_API_TOKEN}",
                                   "Content-Type": "application/vnd.api+json"})
    runs_response = json.loads(urlopen(req).read())

    for run in runs_response["data"]:
        # Discard all planned or pending plans that are not what was just triggered by [heliumcli] for this version
        if (run["attributes"]["status"] in ["planned", "pending"] and
                (not run["attributes"]["message"].startswith("[heliumcli]") or VERSION not in run["attributes"][
                    "message"])):
            reject_endpoint = "cancel" if run["attributes"]["actions"]["is-cancelable"] else "discard"
            req = request.Request(f"https://app.terraform.io/api/v2/runs/{run['id']}/actions/{reject_endpoint}",
                                  headers={"Authorization": f"Bearer {TERRAFORM_API_TOKEN}",
                                           "Content-Type": "application/vnd.api+json"},
                                  data=json.dumps(
                                      {"comment": "Discarding plan in favor of official release plan"}).encode())
            json.loads(urlopen(req).read())
        # Continue to wait until the [heliumcli] plan is in the correct state
        elif (run["attributes"]["status"] == "planned" and
              run["attributes"]["message"].startswith("[heliumcli]") and
              VERSION in run["attributes"]["message"]):
            print(f"... found planned [heliumcli] run for {VERSION} with ID {run['id']}.")
            heliumcli_run = run
            break

    if heliumcli_run:
        break
    else:
        retries += 1
        print("Waiting for Terraform ...")
        time.sleep(retry_sleep_seconds)

if not heliumcli_run:
    print("ERROR: [heliumcli] plan was never found in Terraform.")
    sys.exit(1)

#####################################################################
# Trigger Terraform apply for release
#####################################################################

print(f"Triggering Terraform apply on run ID {heliumcli_run['id']} in {ENVIRONMENT} ...")
req = request.Request(f"https://app.terraform.io/api/v2/runs/{heliumcli_run['id']}/actions/apply",
                      headers={"Authorization": f"Bearer {TERRAFORM_API_TOKEN}",
                               "Content-Type": "application/vnd.api+json"},
                      data=json.dumps({"comments": f"[heliumcli] Apply {VERSION}"}).encode())
resp = urlopen(req)

#####################################################################
# Release frontend code from artifact S3 bucket to live
#####################################################################
s3 = boto3.resource('s3')
source_bucket_name = "heliumedu"
source_bucket = s3.Bucket(source_bucket_name)
dest_bucket_name = f"heliumedu.{ENVIRONMENT}.frontend.static"
dest_bucket = s3.Bucket(dest_bucket_name)


def upload_source_map(s3_key):
    s3_client = boto3.client('s3')

    min_map_url = s3_client.generate_presigned_url(
        'get_object',
        Params={'Bucket': source_bucket_name, 'Key': obj.key},
        ExpiresIn=(60 * 5)
    )

    encoded_data = parse.urlencode({
        'access_token': FRONTEND_ROLLBAR_SERVER_ITEM_ACCESS_TOKEN,
        'version': VERSION,
        'minified_url': min_map_url,
    }).encode('ascii')

    # Create a Request object
    # The 'data' argument expects bytes, which is why the encoded_data is used.
    req = request.Request('https://api.rollbar.com/api/1/sourcemap/download', data=encoded_data, method='POST')

    # Add a Content-Type header to specify that the data is form-urlencoded
    # This is crucial for the server to correctly interpret the POST data.
    req.add_header('Content-Type', 'application/x-www-form-urlencoded')

    # Send the request and get the response
    with request.urlopen(req) as response:
        # Read and decode the response body
        response_body = response.read().decode('utf-8')
        print(f"Response from {obj.key} source map upload: {response_body}")


# Copy assets first, so that new versioned bundles exist before pages are updated

assets_source_prefix = f"helium/frontend/{VERSION}/assets"
assets_dest_prefix = "assets/"
print(f"Copying frontend resources from {source_bucket_name}{assets_source_prefix} to {dest_bucket_name} ...")
for obj in source_bucket.objects.filter(Prefix=assets_source_prefix):
    new_key = f"{assets_dest_prefix}" + obj.key[len(assets_source_prefix):].lstrip("/")

    # Don't move source maps as part of deployment, instead  upload them to Rollbar
    if obj.key.endswith(".min.js.map"):
        if CUT_RELEASE:
            print(f"Uploading JS source map {obj.key}")
            try:
                upload_source_map(obj.key)
            except Exception as e:
                print(f"An error occurred uploading JS source map {obj.key}: {e}")
        else:
            print(f"Skipping JS source map upload of {obj.key}")
    elif ENVIRONMENT != "prod" or not obj.key.endswith(".min.css.map"):
        copy_source = {
            'Bucket': source_bucket_name,
            'Key': obj.key
        }
        dest_bucket.Object(new_key).copy_from(CopySource=copy_source)
        print(f"--> '{obj.key}' to '{new_key}'")
    else:
        print(f"Skipping file {obj.key} in environment {ENVIRONMENT}")

source_prefix = f"helium/frontend/{VERSION}"
print(f"Copying frontend resources from {source_bucket_name}{source_prefix} to {dest_bucket_name} ...")
for obj in source_bucket.objects.filter(Prefix=source_prefix):
    # Skip assets, as we've already moved them in to place
    if obj.key.startswith(assets_source_prefix):
        continue

    new_key = obj.key[len(source_prefix):].lstrip("/")
    copy_source = {
        'Bucket': source_bucket_name,
        'Key': obj.key
    }
    dest_bucket.Object(new_key).copy_from(CopySource=copy_source)
    print(f"--> '{obj.key}' to '{new_key}'")

print(f"... {VERSION} of the frontend is now live in {ENVIRONMENT}.")

#####################################################################
# Wait for the Terraform apply to be live
#####################################################################

version_is_live = False
retries = 0
retry_sleep_seconds = 20
wait_minutes = 10
while retries < ((wait_minutes * 60) / retry_sleep_seconds):
    result = json.load(urlopen(INFO_URI))
    if result["version"] == VERSION:
        version_is_live = True
        break
    else:
        retries += 1
        print(f"Waiting for {ENVIRONMENT} to report version {VERSION} ...")
        time.sleep(retry_sleep_seconds)

if version_is_live:
    print(f"... {VERSION} is now live in {ENVIRONMENT}.")
else:
    print(
        f"ERROR: {ENVIRONMENT} has not updated its version number to {VERSION} within {wait_minutes} minutes, "
        "check if deploy failed.")
    sys.exit(1)
