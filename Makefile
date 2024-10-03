.PHONY: all env install start test provision_ansible_vars

SHELL := /usr/bin/env bash
HELIUMCLI_PROJECTS ?= '["platform", "frontend", "ci-tests"]'
SKIP_UPDATE ?= 'false'

all: env install start

install:
	@python -m pip install -r requirements.txt

	@HELIUMCLI_FORCE_FETCH=True HELIUMCLI_SKIP_UPDATE_PULL=True HELIUMCLI_PROJECTS=$(HELIUMCLI_PROJECTS) helium-cli update-projects

start:
	cd projects/platform && ./bin/runserver
	cd projects/frontend && ./bin/runserver
