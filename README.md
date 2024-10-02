<p align="center"><img src="https://www.heliumedu.com/assets/img/logo_full_blue.png" /></p>

![Python Versions](https://img.shields.io/badge/python-%203.10%20|%203.11%20-blue)
[![Build](https://img.shields.io/github/actions/workflow/status/HeliumEdu/deploy/build.yml)](https://github.com/HeliumEdu/deploy/actions/workflows/build.yml)
![GitHub License](https://img.shields.io/github/license/heliumedu/deploy)

# Deploy Environment

This repository contains everything that is necessary to get a development environment setup on a local machine in
minimal time and to deploy code to other environments using [Docker](https://docs.docker.com/).

## Prerequisites

- A permissioned SSH key at ~/.ssh/id_rsa
- Python (>= 3.10)
- Docker
- Hosts Ubuntu 22.04

## Getting Started

### Docker Development
Here is a minimal set of commands that will get a Docker environment setup locally.

```sh
git clone https://github.com/HeliumEdu/deploy.git ~/Developer/helium
cd ~/Developer/helium
make
```

Done! Now your environment has been initialized, to quickly bring up Docker in the future, simply run `make start`.

For convenience, [helium-cli](https://github.com/HeliumEdu/heliumcli#readme), which is compatible with this
project and provides a useful set of tools for maintaining, building, and deploying the code, has also been installed.

```sh
helium-cli deploy-build main stage --envvars
```

Python projects are run from within their virtualenvs. To run the `python manage.py createsuperuser` command then,
for example, in `/srv/helium/platform`, you need to first activate the virtualenv for the platform. You can do this by
execute like `source $PLATFORM_VENV/bin/activate`.

## Documentation

Auto-generated API documentation is accessible via any environment at /docs. Additional documentation for development,
deployment, setting up environments, and more can be found on the [Deploy Wiki](https://github.com/HeliumEdu/deploy/wiki).
