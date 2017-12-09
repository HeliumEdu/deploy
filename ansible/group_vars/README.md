# Group Vars

This folder contains definitions for [Ansible's inventory](http://docs.ansible.com/ansible/latest/intro_inventory.html).
Configurations for non-dev environments are ignored in Git so they do not get committed by accident.

This folder should contain a committed copy of `all.yml`, inventory items that are applicable to all environments, and
`devbox.yml.example`, an example inventory file that also works with the supplied Vagrant configuration. To get started,
rename `devbox.yml.example` to `devbox.yml`.

Note that credentials to third-party services (for example, AWS services like SES) need to be set in the
`devbox.yml` file before those services will work properly. Do NOT commit real credentials to third-party
services, even in example files.