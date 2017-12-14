# Group Vars

This folder contains definitions for [Ansible's inventory](http://docs.ansible.com/ansible/latest/intro_inventory.html).
Configurations for non-dev environments are ignored in Git so they do not get committed by accident.

This folder should contain a committed copy of `all.yml`, inventory items that are applicable to all environments, and
`devbox.yml.example`, an example inventory file that also works with the supplied Vagrant configuration. To get started,
rename `devbox.yml.example` to `devbox.yml`.

Note that credentials to third-party services (for example, AWS services like SES) need to be set in the
`devbox.yml` file before those services will work properly. Do NOT commit real credentials to third-party
services, even in example files.

## Making a New Inventory Configuration

Aside from the obvious updates that need to be made to any host or credentials variable (note that most hosts in
`devbox.yml.example` end in `.dev`), these are variables should be updated when configuring a new group.

* "environment" should match the name of the group; it is used as a prefix or suffix for server variables (for instance, the name of a datastore) to distinguish between environments
* Any "secret" or "key" should be regenerated; do NOT reuse these between environments
* "platform_host_protocol" should be updated if the new group supports SSL
* "letsencrypt_ssl" can be added and set to "True" if you want to auto-generate and renew SSL certificates and your hosts are resolvable externally
* "project_serve_local", "PROJECT_SERVE_LOCAL", and "PROJECT_DISABLE_EMAILS" can simply be removed from non-dev environments, as they fallback on safe defaults

Note that if the new inventory calls for SSL but does not [Let's Encrypt](https://letsencrypt.org/), the following
corresponding SSL files will need to be in `ansible/private/ssl`:

* apache.{{ environment }}.crt
* apache.{{ environment }}.key
* apache.{{ environment }}.ca-bundle
