<p align="center"><img src="https://www.heliumedu.com/assets/img/logo_full_blue.png" /></p>

![Python Versions](https://img.shields.io/badge/python-%203.10%20|%203.11%20-blue)
[![Build](https://img.shields.io/github/actions/workflow/status/HeliumEdu/deploy/build.yml)](https://github.com/HeliumEdu/deploy/actions/workflows/build.yml)
![GitHub License](https://img.shields.io/github/license/heliumedu/deploy)

# Deploy Environment

This repository contains everything that is necessary to get a development environment setup on a local machine in
minimal time and to deploy code to other environments using [Docker](https://docs.docker.com/).

## Prerequisites

- Docker

## Development
### Docker Setup
Here is a minimal set of commands that will get a Docker environment setup locally.

```sh
git clone https://github.com/HeliumEdu/deploy.git ~/Developer/helium
cd ~/Developer/helium
make
```

Done! Now that your environment has been initialized, to quickly bring up Docker in the future, simply run `make start`.

This project was previous deployed using Ansible. However, now that the project has been Dockerized, we will be
migrating to use Terraform instead. Since the Terraform resources have not yet been added to this project, presently
this project is primarily a placeholder for getting started with the project in Docker and deploying the containers
manually.
