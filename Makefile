.PHONY: all install start run-ci publish

SHELL := /usr/bin/env bash
HELIUMCLI_PROJECTS ?= '["platform", "frontend", "ci-tests"]'
SKIP_UPDATE ?= 'false'

all: install start

install:
	@python -m pip install -r requirements.txt

	@HELIUMCLI_FORCE_FETCH=True HELIUMCLI_SKIP_UPDATE_PULL=True HELIUMCLI_PROJECTS=$(HELIUMCLI_PROJECTS) helium-cli update-projects

build:
	make -C projects/platform build-docker
	make -C projects/frontend build-docker

start:
	cd projects/platform && ./bin/runserver
	cd projects/frontend && ./bin/runserver

run-ci:
	@if [[ -z "${PLATFORM_EMAIL_HOST_USER}" ]] || \
		[[ -z "${PLATFORM_EMAIL_HOST_PASSWORD}" ]] || \
		[[ -z "${PLATFORM_TWILIO_ACCOUNT_SID}" ]] || \
		[[ -z "${PLATFORM_TWILIO_AUTH_TOKEN}" ]] || \
		[[ -z "${PLATFORM_TWILIO_SMS_FROM}" ]] || \
		[[ -z "${PLATFORM_AWS_S3_ACCESS_KEY_ID}" ]] || \
		[[ -z "${PLATFORM_AWS_S3_SECRET_ACCESS_KEY}" ]] || \
		[[ -z "${CI_TWILIO_RECIPIENT_PHONE_NUMBER}" ]]; then \
  	  echo "Set all env vars required to run CI tests end-to-end against a local Docker build: [\
PLATFORM_EMAIL_HOST_USER, \
PLATFORM_EMAIL_HOST_PASSWORD, \
PLATFORM_TWILIO_ACCOUNT_SID, \
PLATFORM_TWILIO_AUTH_TOKEN, \
PLATFORM_TWILIO_SMS_FROM, \
PLATFORM_AWS_S3_ACCESS_KEY_ID, \
PLATFORM_AWS_S3_SECRET_ACCESS_KEY, \
CI_TWILIO_RECIPIENT_PHONE_NUMBER]"; \
      exit 1; \
    fi

	./projects/platform/bin/provision-dot-env.sh
	make start
	PROJECT_APP_HOST=http://localhost:3000 \
    PROJECT_API_HOST=http://localhost:8000 \
    make -C projects/ci-tests

publish:
	make -C projects/platform publish-docker
	make -C projects/frontend publish-docker
