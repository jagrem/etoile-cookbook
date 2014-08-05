#
# Cookbook Name:: etoile-cookbook
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "apt"

# libpng (IconKit)
package 'libpng3' do
  action :install
end

# [zlib](http://www.zlib.net/) (LuceneKit)
package 'zlib-bin' do
  action :install
end

# [OniGuruma](http://www.geocities.jp/kosako3/oniguruma/) 5.0 or higher (OgreKit)
package 'libonig2' do
  action :install
end

# [D-Bus](http://www.freedesktop.org/wiki/Software_2fdbus) 1.0 or higher (System)
package 'libdbus-1-3' do
  action :install
end

# [HAL](http://www.freedesktop.org/wiki/Software_2fhal) (System)
package 'hal' do
  action :install
end

# [startup-notification](http://www.freedesktop.org/wiki/Software_2fstartup_2dnotification) (Azalea)
package 'libstartup-notification0' do
  action :install
end

# [Xcursor](http://www.freedesktop.org/wiki/Software_2fxlibs) (Azalea)
package 'libxcursor1' do
  action :install
end

# [XScreenSaver](http://www.jwz.org/xscreensaver/) (Idle)
package 'xscreensaver' do
  action :install
end

# [LLVM](http://www.llvm.org) (LanguageKit)
package 'llvm' do
  action :install
end

# [Lemon](http://www.hwaci.com/sw/lemon/) (Smalltalk and EScript)
package 'lemon' do
  action :install
end

# [GMP](http://gmplib.org/) (Smalltalk)
# May have to build from source
package 'libgmp10' do
  action :install
end

# [libdispatch](https://libdispatch.macosforge.org/) (CoreObject)
package 'libdispatch0' do
  action :install
end

# [SQLite](http://www.sqlite.org) 3.7 or higher (CoreObject)
package 'sqlite' do
  action :install
end

# [libavcodec and libavformat](http://ffmpeg.mplayerhq.hu/) (MediaKit)
package 'libavcodec53' do
  action :install
end

package 'libavformat53' do
  action :install
end

# [OSS](http://www.opensound.com/) (MediaKit)
package 'oss4-base' do
  action :install
end

# [TagLib](http://developer.kde.org/~wheeler/taglib.html) (Melodie)
package 'libtag1c2a' do
  action :install
end

# [libmp4v2](http://www.mpeg4ip.net/) (Melodie)
package 'libmp4v2-2' do
  action :install
end

# [Graphviz](http://www.graphviz.org/) (DocGenerator)
package 'graphviz' do
  action :install
end

# [Discount](http://www.pell.portland.or.us/~orc/Code/discount/) (DocGenerator)
package 'discount' do
  action :install
end
