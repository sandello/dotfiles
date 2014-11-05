import gdb
import gdb.printing


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


class YtIntrusivePtrPrinter:
    def __init__(self, val):
        self.val = val

    def to_string(self):
        return "intrusive pointer to %s" % self.val["T_"]


def ya_printer():
    pp = gdb.printing.RegexpCollectionPrettyPrinter("yandex")
    pp.add_printer("Stroka", r"^Stroka$", StrokaPrinter)
    pp.add_printer("YtEnumBase", r"^NYT::TEnumBase<", YtEnumBasePrinter)
    pp.add_printer("YtIntrusivePtr", r"^NYT::TIntrusivePtr<", YtIntrusivePtrPrinter)
    return pp


def ya_register(obj):
    gdb.printing.register_pretty_printer(obj, ya_printer())

