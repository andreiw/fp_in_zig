fp/sfp
======

'fullpath', I suppose...

Like realpath, but never symlink
resolves the last component (or expects
it to exist).

Think of this as realpath with the most
obvious and expected behavior.

If invoked as 'sfp', prepends
user@host:, for paths consumable by scp.
This uses your hostname, so be careful.
At some point I may add some smarter behavior
falling back to IP addresses. Or not.
Probably never.

When used with no arguments, acts like pwd.

Building
--------

    $ make

Using
-----

$ ./sfp  *
awarkentin@awarkentin-a02.vmware.com:/Users/awarkentin/src/fp/.git
awarkentin@awarkentin-a02.vmware.com:/Users/awarkentin/src/fp/build.zig
awarkentin@awarkentin-a02.vmware.com:/Users/awarkentin/src/fp/fp
awarkentin@awarkentin-a02.vmware.com:/Users/awarkentin/src/fp/sfp
awarkentin@awarkentin-a02.vmware.com:/Users/awarkentin/src/fp/src
awarkentin@awarkentin-a02.vmware.com:/Users/awarkentin/src/fp/test
awarkentin@awarkentin-a02.vmware.com:/Users/awarkentin/src/fp/zig-cache
awarkentin@awarkentin-a02.vmware.com:/Users/awarkentin/src/fp/zig-out

$ ./fp  *
/Users/awarkentin/src/fp/.git
/Users/awarkentin/src/fp/build.zig
/Users/awarkentin/src/fp/fp
/Users/awarkentin/src/fp/sfp
/Users/awarkentin/src/fp/src
/Users/awarkentin/src/fp/test
/Users/awarkentin/src/fp/zig-cache
/Users/awarkentin/src/fp/zig-out

$ ./fp  does_not_exist
/Users/awarkentin/src/fp/does_not_exist

$ ./fp  ../does_not_exist
/Users/awarkentin/src/does_not_exist

Contact Info
------------

Andrei Warkentin (andrey.warkentin@gmail.com).