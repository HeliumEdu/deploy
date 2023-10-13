#!/usr/bin/env python

import os

BASE_DIR = os.path.normpath(os.path.join(os.path.abspath(os.path.dirname(__file__)), '..'))


def main():
    hosts_path = os.path.join(os.path.join(BASE_DIR, "ansible", "hosts", "stage"))
    with open(hosts_path, "r") as f:
        s = f.read()
    s = s.replace("{%EC2_HOST%}", os.environ.get("EC2_USER"))
    s = s.replace("{%FRONTEND_PUBLIC_DNS%}", os.environ.get("FRONTEND_PUBLIC_DNS"))
    s = s.replace("{%FRONTEND_IP_ADDRESS%}", os.environ.get("FRONTEND_IP_ADDRESS"))
    s = s.replace("{%PLATFORM_WEB_PUBLIC_DNS%}", os.environ.get("PLATFORM_WEB_PUBLIC_DNS"))
    s = s.replace("{%PLATFORM_WEB_IP_ADDRESS%}", os.environ.get("PLATFORM_WEB_IP_ADDRESS"))
    s = s.replace("{%PLATFORM_WORKER_PUBLIC_DNS%}", os.environ.get("PLATFORM_WORKER_PUBLIC_DNS"))
    s = s.replace("{%PLATFORM_WORKER_IP_ADDRESS%}", os.environ.get("PLATFORM_WORKER_IP_ADDRESS"))
    with open(hosts_path, "w") as f:
        f.write(s)

    frontend_path = os.path.join(os.path.join(BASE_DIR, "ansible", "group_vars", "frontend.yml"))
    with open(frontend_path, "r") as f:
        s = f.read()
    s = s.replace("{%DOMAIN_ENVIRONMENT%}", os.environ.get("DOMAIN_ENVIRONMENT"))
    s = s.replace("{%HELIUM_HOST%}", os.environ.get("HELIUM_HOST"))
    s = s.replace("{%PROJECT_DATADOG_API_KEY%}", os.environ.get("PROJECT_DATADOG_API_KEY"))
    s = s.replace("{%PROJECT_DATADOG_APP_KEY%}", os.environ.get("PROJECT_DATADOG_APP_KEY"))
    with open(frontend_path, "w") as f:
        f.write(s)

    platform_path = os.path.join(os.path.join(BASE_DIR, "ansible", "group_vars", "platform.yml"))
    with open(platform_path, "r") as f:
        s = f.read()
    s = s.replace("{%DOMAIN_ENVIRONMENT%}", os.environ.get("DOMAIN_ENVIRONMENT"))
    s = s.replace("{%HELIUM_HOST%}", os.environ.get("HELIUM_HOST"))
    s = s.replace("{%PROJECT_DATADOG_API_KEY%}", os.environ.get("PROJECT_DATADOG_API_KEY"))
    s = s.replace("{%PROJECT_DATADOG_APP_KEY%}", os.environ.get("PROJECT_DATADOG_APP_KEY"))
    s = s.replace("{%ROLLBAR_SERVER_ACCESS_TOKEN%}", os.environ.get("ROLLBAR_SERVER_ACCESS_TOKEN"))
    s = s.replace("{%PLATFORM_DB_HOST%}", os.environ.get("PLATFORM_DB_HOST"))
    s = s.replace("{%PLATFORM_DB_USER%}", os.environ.get("PLATFORM_DB_USER"))
    s = s.replace("{%PLATFORM_AWS_S3_ACCESS_KEY_ID%}", os.environ.get("PLATFORM_AWS_S3_ACCESS_KEY_ID"))
    s = s.replace("{%PLATFORM_AWS_S3_SECRET_ACCESS_KEY%}", os.environ.get("PLATFORM_AWS_S3_SECRET_ACCESS_KEY"))
    s = s.replace("{%PLATFORM_TWILIO_ACCOUNT_SID%}", os.environ.get("PLATFORM_TWILIO_ACCOUNT_SID"))
    s = s.replace("{%PLATFORM_TWILIO_AUTH_TOKEN%}", os.environ.get("PLATFORM_TWILIO_AUTH_TOKEN"))
    s = s.replace("{%PLATFORM_TWILIO_SMS_FROM%}", os.environ.get("PLATFORM_TWILIO_SMS_FROM"))
    s = s.replace("{%PLATFORM_SECRET_KEY%}", os.environ.get("PLATFORM_SECRET_KEY"))
    s = s.replace("{%PLATFORM_CSRF_MIDDLEWARE_SECRET%}", os.environ.get("PLATFORM_CSRF_MIDDLEWARE_SECRET"))
    s = s.replace("{%PLATFORM_EMAIL_HOST_USER%}", os.environ.get("PLATFORM_EMAIL_HOST_USER"))
    s = s.replace("{%PLATFORM_EMAIL_HOST_PASSWORD%}", os.environ.get("PLATFORM_EMAIL_HOST_PASSWORD"))
    s = s.replace("{%PLATFORM_REDIS_HOST%}", os.environ.get("PLATFORM_REDIS_HOST"))
    with open(platform_path, "w") as f:
        f.write(s)


if __name__ == "__main__":
    main()
