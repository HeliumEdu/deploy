#!/usr/bin/env python

import argparse
import sys

from lib import utils
from lib.deploy import DeployAction
from lib.update import UpdateAction
from lib.tag import TagAction
from lib.headers import HeadersAction
from lib.startservers import StartServersAction

__author__ = 'Alex Laird'
__copyright__ = 'Copyright 2018, Helium Edu'
__version__ = utils.VERSION


def main(argv):
    actions = {
        DeployAction(),
        UpdateAction(),
        TagAction(),
        HeadersAction(),
        StartServersAction(),
    }

    parser = argparse.ArgumentParser(prog="helium-cli")
    subparsers = parser.add_subparsers(title="subcommands")

    print(utils.get_title())

    for action in actions:
        action.setup(subparsers)

    if len(argv) == 1:
        parser.print_help()

        return

    args = parser.parse_args()
    args.action.run(args)

    print("")


if __name__ == "__main__":
    main(sys.argv)