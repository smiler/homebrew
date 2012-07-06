require 'formula'

class GtkMacIntegration < Formula
  homepage ''
  url 'http://download.gnome.org/sources/gtk-mac-integration/1.0/gtk-mac-integration-1.0.1.tar.xz'
  sha1 '29bf43caaa132d1834af9a0ce5e5794405afa538'

  depends_on 'autoconf' => :build
#  depends_on 'automake' => :build
  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'glib'
  depends_on 'gtk+'
  depends_on 'gtk-doc' # Needed because of m4 macros

  def patches
    # Backport for new glib
    #'http://git.gnome.org/browse/gtk-mac-integration/patch/?id=0a06046ad35460190eb98f94380d8a2389766935'

    # g_thread_init is deprecated. This is fixed upstream.
    DATA
  end

  def install
    ENV['ACLOCAL_PATH'] = '#{HOMEBREW_PREFIX}/share/aclocal'
    ENV['ACLOCAL_FLAGS'] = "-I #{HOMEBREW_PREFIX}/share/aclocal"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-gtk-doc"
                          "--prefix=#{prefix}"
    system "make install" # if this fails, try separate make/make install steps
  end

end
__END__
diff --git a/src/test-integration.c b/src/test-integration.c
index 8b94d17..7282196 100644
--- a/src/test-integration.c
+++ b/src/test-integration.c
@@ -706,7 +706,6 @@ main (int argc, char **argv)
 #ifdef GTKOSXAPPLICATION
   GtkOSXApplication *theApp;
 #endif //GTKOSXAPPLICATION
-    g_thread_init(NULL);
     gdk_threads_init();
   gtk_init (&argc, &argv);
 #ifdef GTKMACINTEGRATION

