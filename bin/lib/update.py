import os

import git

import utils


class UpdateAction:
    def __init__(self):
        self.name = "update"
        self.help = "Ensure the latest code is checked out for projects"

    def setup(self, subparsers):
        parser = subparsers.add_parser(self.name, help=self.help)
        parser.set_defaults(action=self)

    def run(self, args):
        root_dir = utils.get_root_dir()

        projects_dir = os.path.join(root_dir, "projects")

        repo = git.cmd.Git(root_dir)

        print(os.path.basename(root_dir))
        repo.fetch(tags=True, prune=True)
        print(repo.pull() + "\n")

        if not os.path.exists(projects_dir):
            os.mkdir(projects_dir)

        for project in utils.get_projects():
            print(project)

            project_path = os.path.join(projects_dir, project)

            if not os.path.exists(os.path.join(project_path, ".git")):
                print("Cloning repo to ./projects/{}".format(project))
                git.Repo.clone_from("ssh://git@wash.whitefall.io:7999/den/{}.git".format(project), project_path)

            repo = git.cmd.Git(project_path)

            repo.fetch(tags=True, prune=True)
            print(repo.pull() + "\n")
