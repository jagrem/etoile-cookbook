etoile-cookbook
===============

Description
-----------
The Etoile cookbook is used to provision a development server for developing
applications using the [Etoile](http://etoileos.com/) libraries.

The LLVM and Clang packages for Ubuntu 14.04 are used however GNUstep, libobjc2,
libdispatch and Etoile are compiled from source.

By default GNUstep is installed in `/usr/GNUstep` as are Etoile frameworks, bundles, etc.

Usually you will want to source `/usr/GNUstep/System/Library/Makefiles/GNUstep.sh` in your
`.bashrc` or from the command line.

This cookbook is intended to be used with Vagrant for creating a functioning
development environment.

Requirements
------------

### Chef
* Chef 11+

### Platforms
* Ubuntu 14.04

### Cookbooks

* [apt](https://supermarket.getchef.com/cookbooks/apt)

Attributes
----------
* N/A

Usage
-----

* Add `recipe['etoile-cookbook']` to your node's runlist.

Recipes
-------
* `recipe['etoile-cookbook']`

Author
------
* James McAuley.

License
-------

Released under the [Apache 2 License](LICENSE).
