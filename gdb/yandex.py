import gdb
import re


class StrokaPrinter:
    def __init__(self, val):
        self.val = val
    def to_string(self):
        return self.val["p"]
    def display_hint(self):
        return "string"

class YtEnumBasePrinter:
    def __init__(self, val):
        self.val = val
    def to_string(self):
        return self.val["Value"]


def ya_lookup(val):
    tag = val.type.tag
    if tag is None:
        return None
    if re.match(r"^Stroka$", tag):
        return StrokaPrinter(val)
    if re.match(r"^NYT::TEnumBase<", tag):
        return YtEnumBasePrinter(val)
    return None


def ya_register():
    gdb.pretty_printers.append(ya_lookup)


ya_register()
