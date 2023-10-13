#!/usr/bin/env python

import os

BASE_DIR = os.path.normpath(os.path.join(os.path.abspath(os.path.dirname(__file__)), '..'))


def main():
    hosts_path = os.path.join(os.path.join(BASE_DIR, "ansible", "hosts", "stage"))
    with open(hosts_path, "r") as f:
        s = f.read()
    for var in ["EC2_USER",
                "FRONTEND_PUBLIC_DNS",
                "FRONTEND_IP_ADDRESS",
                "PLATFORM_WEB_PUBLIC_DNS",
                "PLATFORM_WEB_IP_ADDRESS",
                "PLATFORM_WORKER_PUBLIC_DNS",
                "PLATFORM_WORKER_IP_ADDRESS"]:
        s = s.replace("{%" + var + "%}", os.environ.get(var))
    with open(hosts_path, "w") as f:
        f.write(s)

    frontend_path = os.path.join(os.path.join(BASE_DIR, "ansible", "group_vars", "frontend.yml"))
    with open(frontend_path, "r") as f:
        s = f.read()
    for var in ["DOMAIN_ENVIRONMENT",
                "HELIUM_HOST",
                "PROJECT_DATADOG_API_KEY",
                "PROJECT_DATADOG_APP_KEY"]:
        s = s.replace("{%" + var + "%}", os.environ.get(var))
    with open(frontend_path, "w") as f:
        f.write(s)

    platform_path = os.path.join(os.path.join(BASE_DIR, "ansible", "group_vars", "platform.yml"))
    with open(platform_path, "r") as f:
        s = f.read()
    for var in ["DOMAIN_ENVIRONMENT",
                "HELIUM_HOST",
                "PROJECT_DATADOG_API_KEY",
                "PROJECT_DATADOG_APP_KEY",
                "ROLLBAR_SERVER_ACCESS_TOKEN",
                "PLATFORM_DB_HOST",
                "PLATFORM_DB_USER",
                "PLATFORM_AWS_S3_ACCESS_KEY_ID",
                "PLATFORM_AWS_S3_SECRET_ACCESS_KEY",
                "PLATFORM_TWILIO_ACCOUNT_SID",
                "PLATFORM_TWILIO_AUTH_TOKEN",
                "PLATFORM_TWILIO_SMS_FROM",
                "PLATFORM_SECRET_KEY",
                "PLATFORM_CSRF_MIDDLEWARE_SECRET",
                "PLATFORM_EMAIL_HOST_USER",
                "PLATFORM_EMAIL_HOST_PASSWORD",
                "PLATFORM_REDIS_HOST"]:
        s = s.replace("{%" + var + "%}", os.environ.get(var))
    with open(platform_path, "w") as f:
        f.write(s)


if __name__ == "__main__":
    main()
