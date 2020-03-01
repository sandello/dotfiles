#!/usr/bin/env python

import argparse
import difflib
import os
import re
import subprocess
import sys

DOTFILES = os.path.realpath(os.path.expanduser("~/.dotfiles"))
HOME = os.path.realpath(os.path.expanduser("~"))

IGNORE = [
    ".git",
    ".gitignore",
    ".gitmodules",
    "bootstrap.sh",
    "deploy.py",
    "README.md",
]


###############################################################################
# Terminal-related stuff.

class __AnsiCodes(object):
    @staticmethod
    def code_to_chars(code):
        return '\033[' + str(code) + 'm'

    def __init__(self, codes):
        for name in dir(codes):
            if not name.startswith('_'):
                value = getattr(codes, name)
                setattr(self, name, self.code_to_chars(value))


class __AnsiFore:
    BLACK = 30
    RED = 31
    GREEN = 32
    YELLOW = 33
    BLUE = 34
    MAGENTA = 35
    CYAN = 36
    WHITE = 37
    RESET = 39


class __AnsiBack:
    BLACK = 40
    RED = 41
    GREEN = 42
    YELLOW = 43
    BLUE = 44
    MAGENTA = 45
    CYAN = 46
    WHITE = 47
    RESET = 49


class __AnsiStyle:
    BRIGHT = 1
    DIM = 2
    NORMAL = 22
    RESET_ALL = 0

Fore = __AnsiCodes(__AnsiFore)
Back = __AnsiCodes(__AnsiBack)
Style = __AnsiCodes(__AnsiStyle)


def report(entry, action, action_color="yellow"):
    print "{0}{action:>16s}{1} {entry}".format(
        Fore.__dict__[action_color.upper()],
        Fore.__dict__["RESET"],
        entry=entry,
        action=action)


def input(message):
    result = raw_input(message + ": ")
    return result.strip()


def ask(message):
    result = raw_input(message + " (y/N)? ")
    return result.lower() in ["y", "ye", "yes"]


###############################################################################
# Resources.

class Resource(object):
    def __init__(self, entry):
        self.entry = entry

    def repr(self):
        return "<Resource '{}''>".format(self.entry)


class LinkResource(Resource):
    def __init__(self, entry, source, target):
        super(LinkResource, self).__init__(entry)
        self.source = source
        self.target = target

    def provision(self):
        if self._conflicts():
            report(self.entry, "conflict", "yellow")
            if not ask("Overwrite {}".format(self.target)):
                report(self.entry, "skip", "green")
                return
            else:
                report(self.entry, "unlink", "yellow")
                os.unlink(self.target)

        if os.path.lexists(self.target):
            report(self.entry, "link exists", "green")
            return

        report(self.entry, "link", "blue")
        os.symlink(self.source, self.target)

    def _conflicts(self):
        if os.path.lexists(self.target):
            if os.path.islink(self.target):
                return os.readlink(self.target) != self.source
            else:
                return True
        else:
            return False


class RsyncResource(Resource):
    def __init__(self, entry, source, target):
        super(RsyncResource, self).__init__(entry)
        self.source = source
        self.target = target

    def provision(self):
        if not os.path.lexists(self.target):
            os.makedirs(self.target)
        report(self.entry, "rsync", "blue")
        subprocess.check_call([
            "rsync",
            "--exclude", ".git",
            "--exclude", ".DS_Store",
            "--archive",
            "--verbose",
            "--human-readable",
            "--no-perms",
            self.source,
            self.target])


class GitResource(Resource):
    def __init__(self, entry, repo, path):
        super(GitResource, self).__init__(entry)
        self.repo = repo
        self.path = path

    def provision(self):
        if os.path.lexists(self.path):
            report(self.entry, "git exists", "green")
            return

        report(self.entry, "git clone", "blue")
        subprocess.check_call(["git", "clone", self.repo, self.path])


class VundleResource(GitResource):
    VUNDLE_REPO = "https://github.com/VundleVim/Vundle.vim.git"
    VUNDLE_PATH = os.path.join(HOME, ".vim", "bundle", "Vundle.vim")

    def __init__(self):
        super(VundleResource, self).__init__(
            ".vim/bundle/Vundle.vim",
            self.VUNDLE_REPO,
            self.VUNDLE_PATH)

    def provision(self):
        super(VundleResource, self).provision()
        report(self.entry, "vim install", "blue")
        subprocess.check_call(["vim", "+PluginInstall!", "+qall"])


class ZinitResource(GitResource):
    ZINIT_REPO = "https://github.com/zdharma/zinit.git"
    ZINIT_PATH = os.path.join(HOME, ".zinit", "bin")

    def __init__(self):
        super(ZinitResource, self).__init__(
            ".zinit/bin",
            self.ZINIT_REPO,
            self.ZINIT_PATH)


def build_resource_list():
    resources = []
    for entry in sorted(os.listdir(DOTFILES)):
        if entry in IGNORE:
            report(entry, "ignore")
            continue
        elif os.path.isfile(entry):
            build_resource_from_file(entry, resources)
        elif os.path.isdir(entry):
            build_resource_from_directory(entry, resources)
    resources.append(VundleResource())
    resources.append(ZinitResource())
    return resources


def build_resource_from_file(entry, resources):
    source = os.path.join(DOTFILES, entry)
    target = os.path.join(HOME, "." + entry)
    cls = LinkResource

    resources.append(cls(entry, source, target))


def build_resource_from_directory(entry, resources):
    if entry == "bin":
        resources.append(LinkResource(
            entry,
            os.path.join(DOTFILES, entry),
            os.path.join(HOME, entry)))
    elif entry == "gdb" or entry == "vim":
        resources.append(RsyncResource(
            entry,
            os.path.join(DOTFILES, entry) + "/",
            os.path.join(HOME, "." + entry)))
    else:
        report(entry, "omit")


def main():
    parser = argparse.ArgumentParser(description="Deploy dotfiles!")
    parser.add_argument("--bootstrap", action="store_true", help="Bootstrap!")

    if parser.parse_args().bootstrap:
        print "Bootstrapping..."
        if os.path.lexists(DOTFILES):
            if not os.path.isdir(DOTFILES):
                raise RuntimeError("Whoops, " +
                                   "{} should not exist during bootstrap!"
                                   .format(DOTFILES))
        subprocess.check_call([
            "git",
            "clone",
            "--verbose",
            "--progress",
            "--recursive",
            "git@github.com:sandello/dotfiles.git",
            DOTFILES])
        subprocess.check_call([
            "python",
            os.path.join(DOTFILES, "deploy.py")])
    else:
        if DOTFILES != os.path.realpath(os.path.dirname(__file__)):
            raise RuntimeError("Whoops, you are running from a bad-bad place!")
        print "Deploying {} -> {}...".format(DOTFILES, HOME)
        for resource in build_resource_list():
            resource.provision()


if __name__ == "__main__":
    main()
