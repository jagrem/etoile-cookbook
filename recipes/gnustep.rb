#
# Cookbook Name:: etoile-cookbook
# Recipe:: gnustep
#
# Copyright 2014, James McAuley
#
# All rights reserved - Do Not Redistribute
#

# DEPENDENCIES

# make	Required	3.75	current	GNU make
package 'make' do
  version "3.81-8.1ubuntu1"
  action :install
end

# binutils	Depends on OS	2.9.6	current	GNU binutils
package 'binutils' do
  version "2.22-6ubuntu1"
  action :install
end

# iconv	If no glibc	1.7	current	Convert file encoding
package 'libglib2.0-dev' do
  action :install
end

# clang	Recommended	3.3	current	Objective-C Compiler supporting modern 2.0 runtime
package 'llvm-3.4' do
  action :install
end

# gcc	Optional	2.95.3	current	GNU C & Objective-C Compiler
package 'gobjc-4.6' do
    action :install
end

# X11
package 'libx11-6' do
  version "2:1.4.99.1-0ubuntu2.1"
  action :install
end

package 'libx11-dev' do
  version "2:1.4.99.1-0ubuntu2.1"
  action :install
end

package 'libxt-dev' do
  version "1:1.1.1-2ubuntu0.1"
  action :install
end

package 'libxext-dev' do
  action :install
end

package 'xserver-xorg-dev' do
  version "2:1.11.4-0ubuntu10.14"
  action :install
end

# libffi	Required	3.0.9	3.0.13	Message forwarding
package 'libffi6' do
  version "3.0.11~rc1-5"
  action :install
end

# ffcall	Optional	1.8	1.10	Possible alternative to libffi

# gmp	Optional	3.1.1	current	Arbitrary precision arithmetic
package 'libgmp10' do
  action :install
end

# guile	For guile scripting	1.4	current	Scheme language interpreter

# openssl	Recommended	0.9.6b	current	SSL and TSL support
package 'openssl' do
  action :install
end

package 'libssl-dev' do
  action :install
end

package 'libgnutls-dev' do
  action :install
end

# libtiff	Required	3.4036	current	TIFF image support
package 'libtiff4-dev' do
  version "3.9.5-2ubuntu1.6"
  action :install
end

# libpng	Recommended	-	-	PNG image support
package 'libpng3' do
  action :install
end

# libjpeg	Recommended	-	-	JPEG image support
package 'libjpeg8' do
  action :install
end

# libxml	Required	2.3.0	current	For XML property lists and docs
package 'libxml2' do
  version "2.7.8.dfsg-5.1ubuntu4"
  action :install
end

package 'libxml2-dev' do
  version "2.7.8.dfsg-5.1ubuntu4"
  action :install
end

package 'libxslt1-dev' do
  version "1.1.26-8ubuntu1.3"
  action :install
end

package 'libicu-dev' do
  action :install
end

# audiofile	Recommended	0.2.3	current	Program interface to digital audio formats

# WindowMaker	Recommended	0.92.0
# -
# Window manager & desktop
# libobjc2	Recommended	1.7
# -
# Modern ObjectiveC-2.0 support
# libobjc	Required for MinGW/Cygwin, recommended pre gcc4.6	1.7.2
# -
# Updated libobjc for some systems

# GNUSTEP

# gnustep-make 2.6.6 or higher
# gnustep-base trunk (1.24.6 misses some APIs required by CoreObject)
# gnustep-gui trunk
# gnustep-back trunk
# libobjc2 trunk (other ObjC runtimes such as the one packaged with GCC won't work, and libobjc2 1.7 has buggy weak reference support)
remote_file "#{Chef::Config[:file_cache_path]}/gnustep-startup-0.32.0.tar.gz" do
  source 'http://ftpmain.gnustep.org/pub/gnustep/core/gnustep-startup-0.32.0.tar.gz'
end

execute "Unzip startup" do
  cwd '/usr/local'
  command <<-EOF
    mkdir -p /usr/local/gnustep
    tar -xzvf #{Chef::Config[:file_cache_path]}/gnustep-startup-0.32.0.tar.gz -C /usr/local/gnustep
    cd /usr/local/gnustep/gnustep-startup-0.32.0
    ./InstallGNUstep --batch
    EOF
  action :run
end
