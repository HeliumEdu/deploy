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

All projects should now be accessible via https://heliumedu.dev. When changes are made to deployment scripts (project's
contain environmental changes, for instances new migrations), you should use the command below to ensure the `devbox` is
working with the latest environment.

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

If you would like to develop using Vagrant fully offline (after the initial provision), the following environment variables should be disabled:

* PROJECT_DISABLE_EMAILS

## Deployment

The Ansible scripts in this repository, which are also used for configuring Vagrant, are used to deploy to various other environments. The
CLI tool in the `bin` folder is useful for this (and many other things). So, for instance, executing `bin/helium-cli deploy 0.1.0 qa`
will deploy the tag `0.1.0` of all projects to the QA environment, provisioning the nodes as necessary along the way.You can also specify
branches and/or deploy against Vagrant (which is the `devbox` environment), for example `bin/helium-cli deploy feature-27-branch devbox`.

Deployments will not work without an SSH key with permissions at `~/.ssh/id_rsa`, an inventory file for the environment in `ansible/group_vars`, and
necessarily private configuration files (for instance, SSL certificates) in `ansible/private`.

## Making a New Domain Environment

Domain environment's are groups of hosts (or just one, if the environment is small enough) and their associated inventory files. For example,
the deploy command in the section above, `bin/helium-cli deploy v0.1.0 qa` will only work if a `qa` group has been defined under the `ansible`
folder with the necessary hosts and inventory files. This process is described in more detail [here](ansible/README.md).
