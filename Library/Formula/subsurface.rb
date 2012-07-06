require 'formula'

# TODO:
#  - Depend on GTK+ built with quartz (check for libgdk-quartz-2.0.0.dylib ?)
#  - Why is the fix in macos.c needed?

class Subsurface < Formula
  homepage 'https://github.com/torvalds/subsurface/'
  head 'https://github.com/torvalds/subsurface.git'

  depends_on 'glib'
  depends_on 'gtk+'
  depends_on 'libdivecomputer'
  depends_on 'gtk-mac-integration'

  def patches
    # Fix installation path and an OSX specific crash
    DATA
  end

  def install
    ENV['DESTDIR'] = prefix
    system 'make install-macosx'
  end

  def caveats
    s = <<-EOS.undent
      Subsurface.app was installed to:
        #{prefix}

      To link the application to a normal Mac OS X location:
        brew linkapps
      or:
        ln -s #{prefix}/Subsurface.app /Applications

    EOS
    return s
  end
end

__END__
diff --git a/Makefile b/Makefile
index 20dff4c..8bbc380 100644
--- a/Makefile
+++ b/Makefile
@@ -100,7 +100,7 @@ ifeq ($(UNAME), linux)
 else ifeq ($(UNAME), darwin)
 	OSSUPPORT = macos
 	OSSUPPORT_CFLAGS = $(GTK2CFLAGS)
-	MACOSXINSTALL = /Applications/Subsurface.app
+	MACOSXINSTALL = $(DESTDIR)/Subsurface.app
 	MACOSXFILES = packaging/macosx
 	EXTRALIBS = $(shell $(PKGCONFIG) --libs gtk-mac-integration) -framework CoreFoundation
 	CFLAGS += $(shell $(PKGCONFIG) --cflags gtk-mac-integration)
diff --git a/macos.c b/macos.c
index 931d4fa..207942b 100644
--- a/macos.c
+++ b/macos.c
@@ -99,9 +99,11 @@ void subsurface_ui_setup(GtkSettings *settings, GtkWidget *menubar,
 	gtk_osxapplication_set_menu_bar(osx_app, GTK_MENU_SHELL(menubar));
 
 	sep = gtk_ui_manager_get_widget(ui_manager, "/MainMenu/FileMenu/Separator3");
-	gtk_widget_destroy(sep);
+	if (sep != NULL)
+		gtk_widget_destroy(sep);
 	sep = gtk_ui_manager_get_widget(ui_manager, "/MainMenu/FileMenu/Separator2");
-	gtk_widget_destroy(sep);
+	if (sep != NULL)
+		gtk_widget_destroy(sep);
 
 	menu_item = gtk_ui_manager_get_widget(ui_manager, "/MainMenu/FileMenu/Quit");
 	gtk_widget_hide (menu_item);

