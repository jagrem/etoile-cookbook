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
  "llvm-dev",
  "clang",
  "libclang-dev",
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

git "#{Chef::Config[:file_cache_path]}/etoile" do
  repository "https://github.com/etoile/Etoile.git"
  action :sync
end

bash "Fetch all Etoile sources" do
  cwd "#{Chef::Config[:file_cache_path]}/etoile"
  code "./etoile-fetch.sh"
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
  cwd "#{Chef::Config[:file_cache_path]}/core/base"
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

bash "Make and install libdispatch" do
  cwd "#{Chef::Config[:file_cache_path]}/libdispatch/libdispatch"
  code <<-EOF
    . /usr/GNUstep/System/Library/Makefiles/GNUstep.sh
    rm -rf Build
    mkdir Build
    cd Build
    cmake -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_BUILD_TYPE=Release ..
    make && make install
  EOF
end

bash "Link libdispatch libraries" do
  cwd "#{Chef::Config[:file_cache_path]}/libdispatch/libdispatch"
  code <<-EOF
    . /usr/GNUstep/System/Library/Makefiles/GNUstep.sh
    rm -f $GNUSTEP_LOCAL_ROOT/Library/Libraries/libdispatch.so
    ln -s /usr/local/lib/libdispatch.so $GNUSTEP_LOCAL_ROOT/Library/Libraries
    rm -f $GNUSTEP_LOCAL_ROOT/Library/Headers/dispatch
    ln -s /usr/local/include/dispatch $GNUSTEP_LOCAL_ROOT/Library/Headers/dispatch
  EOF
end

bash "Make and install Etoile" do
  cwd "#{Chef::Config[:file_cache_path]}/etoile"
  code <<-EOF
    . /usr/GNUstep/System/Library/Makefiles/GNUstep.sh
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
    make
    make install
  EOF
end
