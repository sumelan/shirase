{
  lib,
  config,
  pkgs,
  flakePath,
  ...
}: let
  inherit
    (lib)
    getExe
    ;
in {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      nautilus
      p7zip-rar # support for encrypted archives
      webp-pixbuf-loader # for webp thumbnails
      xdg-terminal-exec
      ;
  };

  xdg = {
    # fix opening terminal for nemo / thunar by using xdg-terminal-exec spec
    terminal-exec = {
      enable = true;
      settings = {
        default = ["foot.desktop"];
      };
    };

    # fix mimetype associations
    mimeApps.defaultApplications = {
      "inode/directory" = "org.gnome.Nautilus.desktop";
      "application/zip" = "org.gnome.FileRoller.desktop";
      "application/vnd.rar" = "org.gnome.FileRoller.desktop";
      "application/x-7z-compressed" = "org.gnome.FileRoller.desktop";
      "application/x-bzip2-compressed-tar" = "org.gnome.FileRoller.desktop";
      "application/x-tar" = "org.gnome.FileRoller.desktop";
    };

    configFile = {
      "mimeapps.list".force = true;
    };
  };

  gtk.gtk3.bookmarks = let
    homeDir = config.home.homeDirectory;
  in [
    "file://${flakePath}"
    "file://${homeDir}/Downloads"
    "file://${homeDir}/Pictures/Wallpapers"
    "file:///persist Persist"
  ];

  # to find a setting value, run `dconf watch /` in terminal
  dconf.settings = {
    # fix open in terminal
    "org/gnome/desktop/applications/terminal" = {
      exec = getExe pkgs.xdg-terminal-exec;
    };
    "org/gnome/nautilus/icon-view" = {
      default-zoom-level = "small-plus";
    };
  };

  programs.niri.settings = {
    binds = {
      "Mod+O" = {
        action.spawn = ["nautilus"];
        hotkey-overlay.title = ''<span foreground="#37f499">[Application]</span> Nautilus'';
      };
    };

    window-rules = [
      {
        matches = [
          {app-id = "^(org.gnome.Nautilus)$";}
          {app-id = "^(xdg-desktop-portal-gtk)$";}
        ];
        open-floating = true;
        default-column-width.proportion = 0.48;
        default-window-height.proportion = 0.42;
      }
    ];
  };

  custom.persist = {
    home = {
      directories = [
        ".local/share/gvfs-metadata" # folder preferences such as view mode and sort order
      ];
      cache.directories = [
        ".cache/thumbnails" # thumbnail cache
      ];
    };
  };
}
