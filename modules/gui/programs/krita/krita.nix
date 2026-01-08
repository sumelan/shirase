_: {
  flake.modules.homeManager.krita = {pkgs, ...}: {
    home.packages = [pkgs.krita];

    xdg = {
      mimeApps = {
        # remove `krita.desktop` from image mimetypes
        associations.removed = {
          "image/jpeg" = "krita_jpeg.desktop";
          "image/gif" = "krita_gif.desktop";
          "image/webp" = "krita_webp.desktop";
          "image/png" = "krita_png.desktop";
          "application/pdf" = "krita_pdf.desktop";
        };
      };

      # https://ironshark.org/posts/2023-01-artonlinux/
      configFile = {
        kritarc = {
          target = "kritarc";
          source = ./kritarc;
        };
        kritadisplayrc = {
          target = "kritadisplayrc";
          source = ./kritadisplayrc;
        };
        kritashortcutsrc = {
          target = "kritashortcutsrc";
          source = ./kritashortcutsrc;
        };
      };
    };

    custom.persist.home = {
      directories = [
        ".local/share/krita"
      ];
    };
  };
}
