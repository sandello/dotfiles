#!/usr/bin/python

import sys
import os
import os.path

Files = [ s.strip() for s in """
	vimrc
""".split() ]

Distribution = os.path.normpath(os.path.expanduser("~/.home"))
Installation = os.path.normpath(os.path.expanduser("~"))

print >> sys.stderr, "Distribution directory: %s" % (Distribution)

for filename in Files:
	source = os.path.join(Distribution, filename)
	target = os.path.join(Installation, "." + filename)

	print >> sys.stderr, "Shipping file: [%s] -> [%s]..." % (source, target)

	if not os.path.isfile(source):
		print >> sys.stderr, " - Source doesn't exist."
		continue

	if os.path.isfile(target):
		print >> sys.stderr, " - Target already exists; skipping."
		continue

	os.symlink(source, target)

