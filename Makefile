.PHONY: all env install build

all: env install build

env:
	cp -n ansible/group_vars/devbox.yml.example ansible/group_vars/devbox.yml | true

install: env
	pip install -r requirements.txt --user
	bin/helium-cli update

build:
	bin/helium-cli build
