import os
import subprocess

import utils

__author__ = 'Alex Laird'
__copyright__ = 'Copyright 2017, Helium Edu'
__version__ = '0.5.0'


class DeployAction:
    def __init__(self):
        self.name = "deploy"
        self.help = "Perform deployment commands"

    def setup(self, subparsers):
        parser = subparsers.add_parser(self.name, help=self.help)
        parser.add_argument("version", help="The tag version to be deployed")
        parser.add_argument("env", help="The environment to deploy to")
        parser.add_argument("--code", action="store_true", help="Only deploy code")
        parser.add_argument("--envvars", action="store_true", help="Only deploy environment variables")
        parser.add_argument("--conf", action="store_true",
                            help="Only deploy configuration files and restart necessary services")
        parser.add_argument("--ssl", action="store_true",
                            help="Only deploy SSL certificates and restart necessary services")
        parser.set_defaults(action=self)

    def run(self, args):
        hosts = utils.parse_hosts_file(args.env)

        for host in hosts:
            subprocess.call(["scp", os.path.expanduser("~/.ssh/id_rsa"), "ubuntu@" + host + ":~/.ssh/id_rsa"])

            subprocess.call(["ssh", "-t", "ubuntu@" + host,
                             "sudo apt-get update && sudo apt-get install -y python && sudo apt-get -y autoremove"])

        ansible_command = 'ansible-playbook --inventory-file=ansible/hosts -v ansible/' + args.env + '.yml --extra-vars "platform_code_version=' + args.version + '"'

        if args.code or args.envvars or args.conf or args.ssl:
            ansible_command += ' --tags "'
            if args.code:
                ansible_command += "code,"
            if args.envvars:
                ansible_command += "envvars,"
            if args.conf:
                ansible_command += "conf,"
            if args.ssl:
                ansible_command += "ssl,"
            ansible_command = ansible_command.rstrip(',') + '"'

        subprocess.call(ansible_command, shell=True)
