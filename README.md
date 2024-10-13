<p align="center"><img src="https://www.heliumedu.com/assets/img/logo_full_blue.png" /></p>

![Python Versions](https://img.shields.io/badge/python-%203.10%20|%203.11%20-blue)
[![Build](https://img.shields.io/github/actions/workflow/status/HeliumEdu/deploy/build.yml)](https://github.com/HeliumEdu/deploy/actions/workflows/build.yml)
![GitHub License](https://img.shields.io/github/license/heliumedu/deploy)

# Deploy Environment

This repository contains everything that is necessary to get a development environment setup on a local machine using
[Docker](https://docs.docker.com/), as well as the [Terraform](https://app.terraform.io/app) code necessary to provision deployment environments.

## Development
### Docker Setup

Here is a minimal set of commands that will get a Docker environment setup locally.

```sh
git clone https://github.com/HeliumEdu/deploy.git ~/Developer/helium
cd ~/Developer/helium
make
```

Done! Now that your environment has been initialized, to quickly bring up Docker in the future, simply run `make start`.

## Deployment

Use [the Release action](https://github.com/HeliumEdu/deploy/actions/workflows/release.yml) to cut a release and publish container images to
[AWS ECR](https://aws.amazon.com/ecr/). If a [Terraform Workspace](https://developer.hashicorp.com/terraform/cli/workspaces) has been provisioned
and hooks to this repo are setup, then bumping the [Image URI version variable in Terraform](https://github.com/HeliumEdu/deploy/blob/main/terraform/environments/prod/variables.tf#L1)
will trigger a deployment when the Terraform applies, rolling the fleet to this new version.
