import os

import yaml
from configparser import ConfigParser

__author__ = 'Alex Laird'
__copyright__ = 'Copyright 2017, Helium Edu'
__version__ = '0.5.0'

VERSION = "1.0"


def get_title():
    return """\

      ,--.        ,--.  ,---.                               ,--,--.
 ,---.|  |,--,--,-'  '-/  .-',---.,--.--,--,--,--,-----.,---|  `--'
| .-. |  ' ,-.  '-.  .-|  `-| .-. |  .--|        '-----| .--|  ,--.
| '-' |  \ '-'  | |  | |  .-' '-' |  |  |  |  |  |     \ `--|  |  |
|  |-'`--'`--`--' `--' `--'  `---'`--'  `--`--`--'      `---`--`--'
`--'                                                           v{}
""".format(VERSION)


def get_root_dir():
    return os.path.abspath(os.path.join(os.path.dirname(os.path.realpath(__file__)), "..", ".."))


def parse_hosts_file(env):
    config = ConfigParser()
    config.read('ansible/hosts')

    hosts = []
    for section in config.sections():
        if section.startswith(env):
            for item, value in config.items(section):
                split = item.split(' ')
                if len(split) == 2:
                    hosts.append(split[0])

    return hosts


def update(line, verification, start_needle, end_needle=""):
    needs_update = False

    if line.strip().startswith(start_needle) and line.strip().endswith(end_needle):
        if line.strip() != verification:
            needs_update = True

    return needs_update


def get_project_name():
    with open(os.path.join(get_root_dir(), "ansible", "group_vars", "all.yml"), 'r') as stream:
        data = yaml.load(stream)
        return data["default_env_vars"]["PROJECT_NAME"]


def get_projects():
    return [
        "crawler",
        "platform"
    ]
