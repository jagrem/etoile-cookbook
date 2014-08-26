#
# Cookbook Name:: etoile-cookbook
# Recipe:: default
#
# Copyright 2014, James McAuley
#
# All rights reserved - Do Not Redistribute
#
include_recipe "apt"

package "build-essential" do
  action :install
end

package "git" do
  action :install
end

package "subversion" do
  action :install
end

package "ninja" do
  action :install
end

package "cmake" do
  action :install
end

package "libffi-dev" do
  action :install
end

package "libxml2-dev" do
  action :install
end

package "libgnutls-dev" do
  action :install
end

package "libicu-dev" do
  action :install
end

package "libblocksruntime-dev" do
  action :install
end

package "libkqueue-dev" do
  action :install
end

package "libpthread-workqueue-dev" do
  action :install
end

package "autoconf" do
  action :install
end

package "libtool" do
  action :install
end

package "llvm" do
  action :install
end

package "clang" do
  action :install
end

git "#{Chef::Config[:file_cache_path]}/libdispatch" do
  repository "git://github.com/nickhutchinson/libdispatch.git"
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

bash "Compile" do
  code <<-EOF
  echo "export CC=clang"  >> ~/.bashrc
  echo "export CXX=clang++" >> ~/.bashrc
  source ~/.bashrc

  cd /var/chef/cache/libobjc2
  mkdir build
  cd build
  cmake -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ ..
  make
  sudo -E make install

  cd /var/chef/cache/core/make
  ./configure CC=clang CXX=clang++ --enable-debug-by-default --with-layout=gnustep --enable-objc-nonfragile-abi
  make && sudo -E make install
  echo ". /usr/GNUstep/System/Library/Makefiles/GNUstep.sh" >> ~/.bashrc
  source ~/.bashrc

  sudo /sbin/ldconfig

  cd /var/chef/cache/core/base
  ./configure CC=clang CXX=clang++ GNUSTEP_MAKEFILES=/usr/GNUstep/System/Library/Makefiles
  make
  sudo -E make install

  cd /var/chef/cache/libdispatch
  sh autogen.sh
  ./configure CFLAGS="-I/usr/include/kqueue" LDFLAGS="-lkqueue -lpthread_workqueue -pthread -lm"
  make
  sudo -E make install
  sudo ldconfig
EOF
end
