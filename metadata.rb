name             "etoile-cookbook"
maintainer       "James McAuley"
maintainer_email "jagremc@gmail.com"
license          "Apache 2 License"
description      "Installs/Configures etoile-cookbook"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"
recipe           "etoile-cookbook", "Installs a full Etoile development environment."
depends 'apt'
