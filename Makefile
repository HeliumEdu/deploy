.PHONY: all env virtualenv install

SHELL := /usr/bin/env bash
BIN_PATH := $(shell pwd)/bin
HELIUMCLI_PROJECTS ?= '["platform", "frontend", "ci-tests"]'

all: env virtualenv install

env:
	cp -n ansible/group_vars/devbox.yml.example ansible/group_vars/aio.yml | true

install: env
	@python -m pip install -r requirements.txt
	@ansible-galaxy install Datadog.datadog

	mkdir -p bin/lib
	@if [ ! -d "bin/lib/heliumcli" ]; then git clone git@github.com:HeliumEdu/heliumcli.git bin/lib/heliumcli ; fi
	@make install -C bin/lib/heliumcli;
	@ln -sf lib/heliumcli/bin/helium-cli bin/helium-cli

	@if ! cat ~/.bash_profile | grep -q "$(BIN_PATH)" ; then echo "export PATH=\"$(BIN_PATH):\$$PATH\"" >> ~/.bash_profile ; fi

	@HELIUMCLI_PROJECTS=$(HELIUMCLI_PROJECTS) bin/helium-cli update-projects
	@vagrant up
	@mkdir -p ~/.ssh
	@if ! cat ~/.ssh/config | grep -xqFe "Host heliumedu.test" ; then vagrant ssh-config --host heliumedu.test >> ~/.ssh/config ; fi
	@bin/helium-cli deploy-build master devbox
