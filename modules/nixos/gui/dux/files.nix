{pkgs, ...}: let
  inherit (pkgs.lib.generators) toJSON;
in {
  programs.dux-files = {
    enable = true;
    systemd = {
      enable = true;
      target = "graphical-session.target";
      restartIfChanged = true;
    };
    portal = {
      enable = true;
    };
  };

  xdg.portal = {
    config.common = {
      "org.freedesktop.impl.portal.FileChooser" = ["dfiles"];
    };
  };

  hjem.users.sumelan = {
    packages = builtins.attrValues {
      inherit
        (pkgs)
        file-roller
        libheif # HEIC image preview
        p7zip-rar # support for encrypted archives
        webp-pixbuf-loader # for webp thumbnails
        ;
    };

    xdg = {
      config.files = {
        "bookmarks.json" = {
          generator = toJSON {};
          value = import ./_bookmarks.nix {};
        };
        "ui-settings.json" = {
          generator = toJSON {};
          value = import ./_files.nix {};
        };
      };

      # fix mimetype associations
      mime-apps.default-applications = {
        "inode/directory" = "dev.duxlabs.files.desktop";
        "application/zip" = "org.gnome.FileRoller.desktop";
        "application/vnd.rar" = "org.gnome.FileRoller.desktop";
        "application/x-7z-compressed" = "org.gnome.FileRoller.desktop";
        "application/x-bzip2-compressed-tar" = "org.gnome.FileRoller.desktop";
        "application/x-tar" = "org.gnome.FileRoller.desktop";
      };
    };
  };

  custom.fileSystem = {
    persist.home.directories = [
      ".local/share/gvfs-metadata" # folder preferences such as view mode and sort order
    ];
    cache.home.directories = [
      ".cache/thumbnails" # thumbnail cache
    ];
  };
}
