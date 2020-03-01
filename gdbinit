set print array on
set print demangle on
set print object on
set print pretty on
set print static-members on
set print vtbl on

set demangle-style auto

add-auto-load-safe-path /lib
add-auto-load-safe-path /usr/lib

python
import os
import sys
sys.path.insert(0, os.path.expanduser("~/.gdb"))
#import libstdcxx.v6
end

