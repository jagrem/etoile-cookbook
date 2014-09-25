#
# Cookbook Name:: etoile-cookbook
# Recipe:: default
#
# Copyright 2014, James McAuley
#
# All rights reserved.
#
include_recipe "apt"

packages = [
  "subversion",
  "git",
  "llvm-3.4-dev",
  "clang-3.4",
  "cmake",
  "gobjc",
  "libxml2-dev",
  "libxslt1-dev",
  "libffi-dev",
  "libssl-dev",
  "libgnutls-dev",
  "libicu-dev",
  "libjpeg62-dev",
  "libtiff4-dev",
  "libpng12-dev",
  "libgif-dev",
  "libfreetype6-dev",
  "libx11-dev",
  "libcairo2-dev",
  "libxft-dev",
  "libxmu-dev",
  "dbus",
  "libdbus-1-dev",
  "libstartup-notification0-dev",
  "libxcursor-dev",
  "libxss-dev",
  "xscreensaver",
  "g++",
  "libpoppler-dev",
  "libonig-dev",
  "lemon",
  "libgmp3-dev",
  "libsqlite3-dev",
  "libkqueue-dev",
  "libpthread-workqueue-dev",
  "libavcodec-dev",
  "libavformat-dev",
  "libtagc0-dev",
  "libmp4v2-dev",
  "discount",
  "libgraphviz-dev"
]

packages.each do |p|
  package p do
    action :install
  end
end

git "#{Chef::Config[:file_cache_path]}/libdispatch" do
  repository "https://github.com/etoile/libdispatch-objc2"
  action :sync
end

subversion "#{Chef::Config[:file_cache_path]}/core" do
  repository "http://svn.gna.org/svn/gnustep/modules/core"
  action :sync
end

subversion "#{Chef::Config[:file_cache_path]}/libobjc2" do
  repository "http://svn.gna.org/svn/gnustep/libs/libobjc2/trunk"
  action :sync
end

bash "Configure and make GNUstep Make" do
  cwd "#{Chef::Config[:file_cache_path]}/core/make"
  code <<-EOF
    ./configure --enable-debug-by-default --with-layout=gnustep CC=clang CXX=clang++
    make && sudo -E make install
  EOF
end

bash "Make libobjc2" do
  cwd "#{Chef::Config[:file_cache_path]}/libobjc2"
  code <<-EOF
    rm -rf Build
    mkdir Build
    cd Build
    . /usr/GNUstep/System/Library/Makefiles/GNUstep.sh
    cmake -DGNUSTEP_INSTALL_TYPE=SYSTEM -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DTESTS=FALSE ..
    make && make install/strip
  EOF
end

bash "Configure and make GNUstep Make" do
  cwd "#{Chef::Config[:file_cache_path]}/core/make"
  code <<-EOF
    ./configure --enable-debug-by-default --enable-objc-nonfragile-abi --with-layout=gnustep CC=clang CXX=clang++
    make messages=yes && make install
  EOF
end

bash "Configure and make GNUstep base" do
  cwd "#{Chef::Config[:file_cache_path]}/core/make"
  code <<-EOF
    . /usr/GNUstep/System/Library/Makefiles/GNUstep.sh
    ./configure --disable-mixedabi --with-ffi-include=/usr/include/`gcc -dumpmachine` --with-installation-domain=SYSTEM CC=clang CXX=clang++
    make messages=yes && make install
  EOF
end

bash "Configure and make GNUstep gui" do
  cwd "#{Chef::Config[:file_cache_path]}/core/gui"
  code <<-EOF
    . /usr/GNUstep/System/Library/Makefiles/GNUstep.sh
    ./configure CC=clang CXX=clang++
    make messages=yes && make install
  EOF
end

bash "Configure and make GNUstep back" do
  cwd "#{Chef::Config[:file_cache_path]}/core/back"
  code <<-EOF
    . /usr/GNUstep/System/Library/Makefiles/GNUstep.sh
    ./configure CC=clang CXX=clang++
    make messages=yes && make install
  EOF
end

# Build and Install Etoile
# ------------------------
#
# **Note:** If you encounter path related error, you can source GNUstep.sh or
# GNUstep.csh in your shell, read the GNUstep documentation to know more about
# this topic.
#
# - Build and Install libdispatch (requires CMake 2.8 or higher)
#
#   cd ../..
#   git clone https://github.com/etoile/libdispatch-objc2
#   # For more detailed instructions, see libdispatch-lobjc2/INSTALL
#   mkdir libdispatch-objc2/Build
#   cd libdispatch-objc2/Build
#   cmake -DCMAKE_C_COMPILER=clang -DCMAKE_BUILD_TYPE=Release ..
#   make && sudo -E make install
#
# - Build and Install Etoile:
#
#   # Go to the Etoile directory that contains this INSTALL document
#   make # Don't use -j flag
#   [sudo] [-E] make install
#
# **Warning:** If *Smalltalk.h not found* is reported, then it is usually because the -j flag was passed to GNUstep Make. GNUstep Make sometimes doesn't track the dependencies correctly for compiling SmalltalkParser.
#
#
# Uninstall Etoile
# ----------------
#
#   # Go to the Etoile directory that contains this INSTALL document
#   [sudo] [-E] make uninstall
#
#
# Custom Build and Install
# ------------------------
#
# In order to build and install the whole project (with the exception of
# developers tools like UnitKit), you can just type in the root directory (named
# Etoile):
#
#   make
#   [sudo] [-E] make install
#
# You can choose to build only custom set of modules. Add a 'modules.make' file in
# the root directory named 'Etoile' that contains Frameworks, Services and so on.
# In this file, to turn on the module CoreObject and off the module UnitKit, write:
#
# export coreobject = yes
# export unitkit = no
#
# Be careful to have no trailing spaces after 'yes' or 'no'.
# Take also note by declaring these variables, you only determine whether these
# specific modules are built or not, but the build system won't automatically
# resolve and turn on and off dependencies in relation to those modules. So you
# must keep track by yourself of the dependencies to be enabled or disabled. These
# dependencies are usually documented in Frameworks/GNUmakefile and similar
# directories. They can also always be found by looking at the linker flags for
# each module GNUmakefile.
#
# You can use the 'make' command with all the available options from every
# projects directory.
#
# You can also build test bundles for any specified modules by adding an option
# 'test=yes', in future you should be able to run every test bundles with 'make
# check' but this is not implemented currently.
#
#
# Generate Documentation
# ----------------------
#
# To build both the code and the documentation at the same time in any directory, type:
#
#   make documentation=yes
#
# In addition, you can also generate the documentation without building the code per module. Move to a module directory (e.g. cd Languages/LanguageKit) and do:
#
#   make doc
#
# Every time you generate some documentation, a Documentation directory appears per module (e.g. Languages/LanguageKit/Documentation) and it gets consolidated in Developer/Documentation. You can browse the Developer/Documentation/index.html as a starting point.
# If you are in a module directory, you can browse its documentation with Documentation/index.html (e.g. Languages/LanguageKit/Documentation/index.html)
#
# To clean the generated documentation in the current module directory (will also clean the content copied in Developer/Documentation):
#
#   make clean-doc
#
# Finally to remove all the generated documentation, you can use in any directory:
#
#   make distclean
#
# which also discards the code previously built.
#
#
# Trouble
# -------
#
# Give us feedback! Tell us what you like; tell us what you think
# could be better. Send bug reports and patches to <https://github.com/etoile/Etoile>.
