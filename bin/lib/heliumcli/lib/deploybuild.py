import subprocess

from . import utils

__author__ = 'Alex Laird'
__copyright__ = 'Copyright 2018, Helium Edu'
__version__ = '1.1.0'


class DeployBuildAction:
    def __init__(self):
        self.name = "deploy-build"
        self.help = "Deploy the specified build"

    def setup(self, subparsers):
        parser = subparsers.add_parser(self.name, help=self.help)
        parser.add_argument("version", help="The tag version to be deployed")
        parser.add_argument("env", help="The environment to deploy to")
        parser.add_argument('--hosts', action='store', type=str, nargs='*', help="Limit the hosts to be deployed")
        parser.add_argument("--migrate", action="store_true", help="Install code dependencies and run migrations")
        parser.add_argument("--code", action="store_true", help="Only deploy code")
        parser.add_argument("--envvars", action="store_true", help="Only deploy environment variables")
        parser.add_argument("--conf", action="store_true",
                            help="Only deploy configuration files and restart necessary services")
        parser.add_argument("--ssl", action="store_true",
                            help="Only deploy SSL certificates and restart necessary services")
        parser.set_defaults(action=self)

    def run(self, args):
        root_dir = utils.get_deploy_root_dir()
        version = args.version.lstrip("v")
        hosts = utils.parse_hosts_file(args.env)

        subprocess.call('ansible-galaxy install Datadog.datadog', shell=True)

        for host in hosts:
            subprocess.call(["ssh", "-t", "{}@{}".format(host[0], host[1]),
                             "sudo apt-get update && sudo apt-get install -y python && sudo apt-get -y autoremove"])

        ansible_command = 'ansible-playbook --inventory-file={}/ansible/hosts -v {}/ansible/{}.yml --extra-vars ' \
                          '"build_version={}"'.format(root_dir, root_dir, args.env, version)

        if args.migrate or args.code or args.envvars or args.conf or args.ssl:
            tags = []
            if args.code:
                tags.append("code")
            if args.migrate:
                tags.append("migrate")
            if args.envvars:
                tags.append("envvars")
            if args.conf:
                tags.append("conf")
            if args.ssl:
                tags.append("ssl")
            ansible_command += ' --tags "{}"'.format(",".join(tags))

        if args.hosts:
            ansible_command += ' --limit "{}"'.format(",".join(args.hosts))

        subprocess.call(ansible_command, shell=True)
