require 'formula'

class Libdivecomputer < Formula
  homepage 'http://www.divesoftware.org/libdc/'
  url 'http://www.divesoftware.org/libdc/releases/libdivecomputer-0.1.0.tar.gz'
  sha1 '8af6d1b02a1897fddfa3bbf4d7717fa54ac69b34'

  head 'git://libdivecomputer.git.sourceforge.net/gitroot/libdivecomputer/libdivecomputer'

  depends_on 'pkg-config' => :build

  def patches
    # Fix generated pkg-config include path in HEAD
    DATA if ARGV.build_head?
  end

  def install
    
    system "autoreconf", "--install" if ARGV.build_head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff --git a/libdivecomputer.pc.in b/libdivecomputer.pc.in
index aa45720..b5f1274 100644
--- a/libdivecomputer.pc.in
+++ b/libdivecomputer.pc.in
@@ -8,4 +8,4 @@ Description: A library for communication with various dive computers.
 Version: @VERSION@
 Requires.private: @DEPENDENCIES@
 Libs: -L${libdir} -ldivecomputer
-Cflags: -I${includedir}
+Cflags: -I${includedir}/libdivecomputer

