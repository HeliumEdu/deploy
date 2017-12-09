# Deployment Environment

This repository contains everything that is necessary to get a development environment setup on a local machine in minimal time and to deploy code to
other environments.

## Prerequisites

Before you can initialize the project and all dependencies, ensure you have the following prerequisites:

* HTTP access to Git server
* SSH key with access to Git server, stored locally at ~/.ssh/id_rsa
* Python (>= 2.7)
* Pip (>= 9.0)
* Git (>= 1.7.1)
* VirtualBox (>= 5.0.28)
* Vagrant (>= 1.8.4)
* Ansible (>= 2.2)

## Getting Started

Here is a minimal set of commands that will get a local development environment up and running:

```
git clone ssh://git@github.com:HeliumEdu/deploy.git ~/Developer/helium
cd ~/Developer/helium
make install
vagrant up
```

Done!

All projects should now be accessible via https://heliumedu.dev. Provisioning the Vagrant box happens automatically the first time you bring it
but in the future, if Ansible scripts have been changed, or if migrations were modified and projects need to be rebuilt and remigrated, you can
reprovision the box anytime without causing harm by executing

```
vagrant provision
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

The Ansible scripts in this repository, which are used for configuring Vagrant, can also be used to deploy to various other environments. The
CLI tool in the `bin` folder is useful for this (and many other things). So, for instance, executing `bin/helium-cli deploy v0.1.0 qa`
will deploy the tag `v0.1.0` of all projects to the QA environment, provisioning the nodes as necessary along the way.

Deployments will not work without the `devops` SSH key at `~/.ssh/id_rsa`, an inventory file for the environment in `ansible/group_vars`, and
necessarily private configuration files (for instance, SSL certificates) in `ansible/private`.
