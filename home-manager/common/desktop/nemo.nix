{
  lib,
  config,
  pkgs,
  flakePath,
  ...
}: let
  inherit (lib) getExe;
in {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      nemo-with-extensions
      nemo-fileroller
      p7zip-rar # support for encrypted archives
      webp-pixbuf-loader # for webp thumbnails
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
      "inode/directory" = "nemo.desktop";
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
  in
    [
      "file://${homeDir}/Documents"
      "file://${homeDir}/Music"
      "file://${homeDir}/Pictures/Wallpapers"
      "file://${homeDir}/Pictures/Screenshots"
      "file://${homeDir}/Videos"
      "file://${homeDir}/Downloads"
    ]
    ++ [
      "file://${flakePath} Shirase"
      "file:///persist Persist"
    ];

  # NOTE: to find a setting value, run `dconf watch /` in terminal
  dconf.settings = {
    # fix open in terminal
    "org/gnome/desktop/applications/terminal" = {
      exec = getExe config.xdg.terminal-exec.package;
    };
    "org/cinnamon/desktop/applications/terminal" = {
      exec = getExe config.xdg.terminal-exec.package;
    };
    "org/nemo/window-state" = {
      start-with-menu-bar = false;
      side-pane-view = "tree";
      sidebar-width = 195;
    };
    "org/nemo/preferences" = {
      disable-menu-warning = true;
      close-device-view-on-device-eject = true;
      thumbnail-limit = lib.hm.gvariant.mkUint64 (100 * 1024 * 1024); # 100 mb
    };
    "org/nemo/preferences/menu-config" = {
      selection-menu-make-link = true;
      selection-menu-copy-to = true;
      selection-menu-move-to = true;
    };
  };

  programs.niri.settings = {
    binds = {
      "Mod+O" = {
        action.spawn = ["nemo"];
        hotkey-overlay.title = ''<span foreground="#5E81AC">[Application]</span> Nemo'';
      };
    };

    window-rules = [
      {
        matches = [
          {app-id = "^(nemo)$";}
          {app-id = "^(xdg-desktop-portal-gtk)$";}
        ];
        open-floating = true;
        default-column-width.proportion = 0.48;
        default-window-height.proportion = 0.48;
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
