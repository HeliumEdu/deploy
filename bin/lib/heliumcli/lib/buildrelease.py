import os
import shutil
import subprocess

import git

from . import utils

__author__ = 'Alex Laird'
__copyright__ = 'Copyright 2018, Helium Edu'
__version__ = '1.1.0'


class BuildReleaseAction:
    def __init__(self):
        self.name = "build-release"
        self.help = "Build a release version for all projects, tagging when complete"

    def setup(self, subparsers):
        parser = subparsers.add_parser(self.name, help=self.help)
        parser.add_argument("version", help="The version number to be tagged")
        parser.set_defaults(action=self)

    def run(self, args):
        config = utils.get_config()
        root_dir = utils.get_deploy_root_dir()
        projects_dir = os.path.join(root_dir, "projects")

        # First ensure all repos are in a clean state with all changes committed
        dirty_repos = []
        for project in config["projects"]:
            repo = git.Repo(os.path.join(root_dir, "projects", project))

            if repo.untracked_files or repo.is_dirty():
                dirty_repos.append(project)
            else:
                repo.git.checkout("master")

        if len(dirty_repos) > 0:
            print("WARN: this operation cannot be performed when a repo is dirty. Commit all changes to the following "
                  "repos before proceeding: {}".format(dirty_repos))

            return

        version = args.version.lstrip("v")

        self._update_version_file(version,
                                  os.path.join(config["versionInfo"]["project"], config["versionInfo"]["path"]))

        subprocess.call([os.path.join(root_dir, "bin", "helium-cli"), "--silent", "update-headers"])

        print("Committing changes and creating release tags ...")

        for project in config["projects"]:
            print(project)
            self._commit_and_tag(os.path.join(projects_dir, project), version)

        print(os.path.basename(root_dir))
        self._commit_and_tag(root_dir, version)

        print("... release version {} built.".format(version))

    def _commit_and_tag(self, path, version):
        repo = git.Repo(path)

        if version in repo.tags:
            print("Version already exists, not doing anything")
        else:
            if repo.is_dirty():
                repo.git.add(u=True)
                repo.git.commit(m='Release {}'.format(version))
                repo.remotes["origin"].push("master")
            tag = repo.create_tag(version, m="")
            repo.remotes["origin"].push(tag)

    def _update_version_file(self, version, path):
        config = utils.get_config()
        root_dir = utils.get_deploy_root_dir()
        projects_dir = os.path.join(root_dir, "projects")

        version_file_path = os.path.join(projects_dir, path)

        version_file = open(version_file_path, "r")
        new_version_file = open(version_file_path + ".tmp", "w")

        for line in version_file:
            if version_file_path.endswith(".py"):
                if line.strip().startswith("__version__ ="):
                    line = "__version__ = '{}'\n".format(version)
            elif version_file.name == "package.json":
                if line.strip().startswith("\"version\":"):
                    line = "  \"version\": \"{}\",\n".format(version)
            else:
                print("WARN: helium-cli does not know how to process this type of file for version file: {}".format(
                    config["versionInfo"]["path"]))

                new_version_file.close()
                os.remove(version_file_path + ".tmp")

                return

            new_version_file.write(line)

        version_file.close()
        new_version_file.close()

        shutil.copy(version_file_path + ".tmp", version_file_path)
        os.remove(version_file_path + ".tmp")
