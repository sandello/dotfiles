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


def input(message):
    result = raw_input(message + ": ")
    return result.strip()


def ask(message):
    result = raw_input(message + " (y/N)? ")
    return result.lower() in ["y", "ye", "yes"]


###############################################################################
# Resources.

class Resource(object):
    def __init__(self, entry, source, target):
        self.entry = entry
        self.source = source
        self.target = target

    def exists(self):
        return os.path.lexists(self.target)

    def conflicts(self):
        return os.path.lexists(self.target)

    def undeploy(self):
        return os.unlink(self.target)

    def deploy(self):
        raise NotImplementedError

    def repr(self):
        return "<Resource '{}''>".format(self.entry)


class TemplateResource(Resource):
    class InteractiveDict(dict):
        def __missing__(self, key):
            self[key] = input(key)
            return self[key]

    def __init__(self, *args, **kwargs):
        super(TemplateResource, self).__init__(*args, **kwargs)
        self.cache = self.InteractiveDict()

    def conflicts(self):
        if os.path.lexists(self.target):
            with open(self.target, "r") as handle:
                expected = self.render()
                actual = handle.read()
                if expected != actual:
                    for line in difflib.unified_diff(actual, expected):
                        sys.stdout.write(line)
                    sys.stdout.flush(line)
                    return True
                else:
                    return False
        else:
            return False

    def deploy(self):
        with open(self.target, "w") as handle:
            report(self.entry, "template", "green")
            handle.write(self.render())

    def render(self):
        def cb(match):
            return self.cache[match.group(1)]
        with open(self.source, "r") as handle:
            result = handle.read()
            result = re.sub(r"<%=\s*(.+?)\s* %>", cb, result)
            return result


class LinkResource(Resource):
    def __init__(self, *args, **kwargs):
        super(LinkResource, self).__init__(*args, **kwargs)

    def conflicts(self):
        if os.path.lexists(self.target):
            if os.path.islink(self.target):
                return os.readlink(self.target) != self.source
            else:
                return True
        else:
            return False

    def deploy(self):
        report(self.entry, "symlink", "green")
        os.symlink(self.source, self.target)


class VundleResource(Resource):
    def __init__(self):
        super(VundleResource, self).__init__(
            ".vim/bundle/vundle",
            None,
            os.path.join(HOME, ".vim", "bundle", "vundle"))

    def conflicts(self):
        return False

    def deploy(self):
        os.makedirs(self.target)
        subprocess.check_call([
            "git",
            "clone",
            "https://github.com/gmarik/vundle.git",
            self.target])
        subprocess.check_call([
            "vim",
            "+BundleInstall",
            "+qall"])


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
    resources.append(VundleResource())
    return resources


def build_resource_from_file(entry, resources):
    source = os.path.join(DOTFILES, entry)
    target = os.path.join(HOME, "." + entry)
    cls = LinkResource

    if entry.endswith(".tt"):
        target = target[:-3]
        cls = TemplateResource

    resources.append(cls(entry, source, target))


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
            if resource.conflicts():
                report(resource.entry, "conflict")
                if not ask("Overwrite {}".format(resource.target)):
                    report(resource.entry, "skip")
                    continue
                else:
                    report(resource.entry, "remove")
                    resource.undeploy()
            if resource.exists():
                report(resource.entry, "exists", "green")
            else:
                resource.deploy()


if __name__ == "__main__":
    main()
