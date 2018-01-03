# Deployment Environment

This repository contains everything that is necessary to get a development environment setup on a local machine in minimal time and to deploy code to
other environments.

## Prerequisites

Before you can initialize the project and all dependencies, ensure you have the following prerequisites:

* HTTP access to Git server
* SSH key with access to Git server, stored locally at ~/.ssh/id_rsa
* Python (>= 2.7)
* Pip (>= 9.0)
* Git (>= 1.7)
* VirtualBox (>= 5.1)
* Vagrant (>= 1.9)
* Ansible (>= 2.2)

## Getting Started

Here is a minimal set of commands that will get a local development environment up and running:

```
git clone git@github.com:HeliumEdu/deploy.git ~/Developer/helium
cd ~/Developer/helium
make install
```

Done!

All projects should now be accessible via https://heliumedu.dev, and API documentation can now also be viewed at
https://heliumedu.dev/docs. When changes are made to deployment scripts (project's contain environmental changes, for instances
new migrations), you should use the command below to ensure the `devbox` is working with the latest environment.

```
bin/helium-cli deploy master devbox
```

The shell into the VM, execute:

```
vagrant ssh
```

To power down the VM, execute:

```
vagrant halt
```

## Offline Development

To develop using Vagrant fully offline (after the initial provision), the following environment variables should be set to `False`:

* PROJECT_DISABLE_EMAILS

## Deployment

The Ansible scripts in this repository can be used to deploy to any environment, production to a local Vagrant—the CLI tool
in the `bin` folder is useful for this and many other things. So, for instance, executing `bin/helium-cli deploy 0.1.0 qa`
will deploy the tag `0.1.0` of all projects to the QA environment, provisioning the nodes as necessary along the way.
Alternatively, a branch can also be specified, for example `bin/helium-cli deploy feature-27-branch devbox`.

Remote deployments will not work without a permissioned SSH key at `~/.ssh/id_rsa`, an inventory file for the given environment
in `ansible/group_vars`, and the necessary private configuration files (for instance, SSL certificates) in `ansible/private`.

## Making a New Environment Configuration

Environment's are groups of hosts (or just one, if the environment is a small, all-in-one host) and their associated inventory files. For example,
the deploy command in the section above `bin/helium-cli deploy v0.1.0 qa` will only work if a `qa` group has been defined under the `ansible`
folder with the necessary hosts and inventory files. This process is described in more detail [here](ansible).

## Serving Static and Media Securely from S3

In any non-dev environment, the `project_serve_local` and `PROJECT_SERVE_LOCAL` variables should be _removed_, and
`PLATFORM_AWS_S3_ACCESS_KEY_ID` and `PLATFORM_AWS_S3_SECRET_ACCESS_KEY` must be _set_. Doing this will cause the
platform to rely on S3 to serving up static and media files reliably and securely.

Before this will work fully, a few things need to be setup. First, the buckets
`heliumedu.{{ domain_environment }}.static` and `heliumedu.{{ domain_environment }}.media` must exist (change the
environment variables to use different names).

Lastly, the `static` bucket must be setup to allow public reads. To do this, set the following Bucket Policy:

```
{
    "Version": "2012-10-17",
    "Statement": [
       {
           "Sid": "AddPerm",
           "Effect": "Allow",
           "Principal": "*",
           "Action": "s3:GetObject",
           "Resource": "arn:aws:s3:::heliumedu.{{ domain_environment }}.static/*"
       }
    ]
}
```

And the follow CORS Configuration:

```
<?xml version="1.0" encoding="UTF-8"?>
<CORSConfiguration xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
<CORSRule>
    <AllowedOrigin>*</AllowedOrigin>
    <AllowedMethod>GET</AllowedMethod>
    <MaxAgeSeconds>3000</MaxAgeSeconds>
    <AllowedHeader>Authorization</AllowedHeader>
</CORSRule>
</CORSConfiguration>
```

Now you're all setup. Rerun the `bin/helium-cli` deployment command and the environment will be reprovisioned to rely on
this new configuration.