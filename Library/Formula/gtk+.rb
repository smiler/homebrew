require 'formula'

# TODO: 
#  Depend on cairo with quartz
#  Document patches

class Gtkx < Formula
  homepage 'http://gtk.org/'
  url 'http://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/gtk+-2.24.10.tar.xz'
  sha256 'ea56e31bb9d6e19ed2e8911f4c7ac493cb804431caa21cdcadae625d375a0e89'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'glib'
  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on 'gdk-pixbuf'
  depends_on 'pango'
  depends_on 'jasper' => :optional
  depends_on 'atk' => :optional
  depends_on 'cairo'
  depends_on :x11

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def patches
    # See patches from https://trac.macports.org/browser/trunk/dports/gnome/gtk2
    { :p0 => [
              'https://trac.macports.org/export/95028/trunk/dports/gnome/gtk2/files/patch-aliases.diff',
              'https://trac.macports.org/export/95028/trunk/dports/gnome/gtk2/files/patch-gtk-builder-convert.diff',
              'https://trac.macports.org/export/95028/trunk/dports/gnome/gtk2/files/patch-tests_Makefile.in.diff'
             ]
    }
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-glibtest",
                          "--disable-introspection",
                          "--with-gdktarget=quartz",
                          "--enable-quartz-relocation",
                          "--disable-visibility"
    system "make install"
  end

  def test
    system "#{bin}/gtk-demo"
  end
end
