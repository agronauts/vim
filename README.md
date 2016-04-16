Vim 64-bit build for Windows
============================

64-bit Vim for 64-bit Windows, with 64-bit Python 2.7 and 3.5 support, 64-bit
Lua 5.3 support, and 64-bit Ruby 2.3.0 support. Compiled with HUGE feature set
and full optimizations for speed with Visual Studio 2013. Both the GUI and
console executables are included.

Updated approximately every week. Latest versions can always be downloaded
[here] (https://bintray.com/veegee/generic/vim_x64)

If you would like support for a feature that's not enabled, please email me at
veegee@veegee.org and I will add it in.

Installing
============

* Simply run the installer to install.
* If you would like a portable installation, "extract" the installer using
  [7-zip] (http://7-zip.org).

Enabling Optional Features
==========================

Python
------

python27.dll and python35.dll must be in your PATH if you would like to make use
of the respective Python features. This is done for you by default if you
installed Python via the standard Windows installers.

Note: If Python 2.7.11 does not seem to work, please use Python 2.7.10 until a
solution is found.

Ruby
----

x64-msvcr120-ruby230.dll must be in your PATH to enable Ruby support. One way to
get this file is by compiling Ruby 2.3 with VS2013.

Lua
---

lua53.dll must be in your PATH if you would like to enable support for Lua. You
can download Lua binaries here: http://luabinaries.sourceforge.net/

<!-- vim: set tw=80 nospell: -->
