import os
import subprocess

import utils

__author__ = 'Alex Laird'
__copyright__ = 'Copyright 2017, Helium Edu'
__version__ = '0.5.0'


class BuildAction:
    def __init__(self):
        self.name = "build"
        self.help = "Build projects"

    def setup(self, subparsers):
        parser = subparsers.add_parser(self.name, help=self.help)
        parser.set_defaults(action=self)

    def run(self, args):
        root_dir = utils.get_root_dir()

        project_name = os.path.basename(root_dir)

        for dir in os.listdir(os.path.join(root_dir, "projects")):
            if dir == ".DS_Store":
                continue

            subprocess.call('vagrant ssh -c "cd /srv/{}/{} && make"'.format(project_name, dir), shell=True)
