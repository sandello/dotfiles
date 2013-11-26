#!/usr/bin/env python

import argparse
import os
import subprocess

DOTFILES = os.path.realpath(os.path.expanduser("~/.dotfiles"))
HOME = os.path.realpath(os.path.expanduser("~"))

IGNORE = [
    ".git",
    ".gitignore",
    ".gitmodules",
    "bootstrap.sh",
    "deploy.py",
    "README",
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
    print "{0}{action:>12s}{1} {entry}".format(
        Fore.__dict__[action_color.upper()],
        Fore.__dict__["RESET"],
        entry=entry,
        action=action)


def ask(message):
    result = raw_input(message + " (y/N)? ")
    return result.lower() in ["y", "ye", "yes"]


###############################################################################
# Resources.

class Resource(object):
    def __init__(self, entry):
        self.entry = entry

    def deploy(self):
        raise NotImplementedError

    def repr(self):
        return "<Resource '{}''>".format(self.entry)


class LinkResource(Resource):
    def __init__(self, entry, source, target):
        self.entry = entry
        self.source = source
        self.target = target

    def deploy(self):
        if os.path.lexists(self.target):
            if os.path.islink(self.target):
                if os.readlink(self.target) == self.source:
                    report(self.entry, "exists", "green")
                    return
            report(self.entry, "conflict", "red")
            if not ask("Overwrite {}".format(self.target)):
                report(self.entry, "skip")
                return
            else:
                report(self.entry, "remove", "red")
                os.unlink(self.target)
        report(self.entry, "symlink", "green")
        os.symlink(self.source, self.target)


def build_resource_list():
    resources = []
    for entry in os.listdir(DOTFILES):
        if entry in IGNORE:
            report(entry, "ignore")
            continue
        elif os.path.isfile(entry):
            build_resource_from_file(entry, resources)
        elif os.path.isdir(entry):
            build_resource_from_directory(entry, resources)
    return resources


def build_resource_from_file(entry, resources):
    resources.append(LinkResource(
        entry,
        os.path.join(DOTFILES, entry),
        os.path.join(HOME, "." + entry)))


def build_resource_from_directory(entry, resources):
    if entry == "bin":
        resources.append(LinkResource(
            entry,
            os.path.join(DOTFILES, entry),
            os.path.join(HOME, entry)))
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
            resource.deploy()


if __name__ == "__main__":
    main()
