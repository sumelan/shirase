{
  lib,
  config,
  pkgs,
  user,
  flakePath,
  ...
}: let
  inherit
    (lib)
    getExe
    ;

  inherit
    (lib.gvariant)
    mkUint64
    ;
in {
  home.packages = with pkgs;
    [nemo-with-extensions]
    ++ [
      p7zip-rar # support for encrypted archives
      nemo-fileroller
      webp-pixbuf-loader # for webp thumbnails
      xdg-terminal-exec
    ];

  xdg = {
    # fix opening terminal for nemo / thunar by using xdg-terminal-exec spec
    terminal-exec = {
      enable = true;
      settings = {
        default = ["${config.profiles.${user}.defaultTerminal.name}.desktop"];
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
  in [
    "file://${flakePath}"
    "file://${homeDir}/Downloads"
    "file://${homeDir}/Pictures/Wallpapers"
    "file:///persist Persist"
  ];

  dconf.settings = {
    # fix open in terminal
    "org/gnome/desktop/applications/terminal" = {
      exec = getExe pkgs.xdg-terminal-exec;
    };
    "org/cinnamon/desktop/applications/terminal" = {
      exec = getExe pkgs.xdg-terminal-exec;
    };
    "org/nemo/preferences" = {
      default-folder-viewer = "icon-view";
      show-hidden-files = false;
      start-with-dual-pane = false;
      date-format-monospace = true;
      # needs to be a uint64!
      thumbnail-limit = mkUint64 (100 * 1024 * 1024); # 100 mb
    };
    "org/nemo/window-state" = {
      start-with-menu-bar = false;
      start-with-status-bar = false;
      sidebar-bookmark-breakpoint = 0;
      sidebar-width = 180;
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
        action.spawn = ["sh" "-c" "uwsm app -- nemo"];
        hotkey-overlay.title = ''<span foreground="${config.lib.stylix.colors.withHashtag.base0B}">[Application]</span> Nemo'';
      };
    };

    window-rules = [
      {
        matches = [
          {
            app-id = "^(nemo)$";
          }
          {
            app-id = "^(xdg-desktop-portal-gtk)$";
          }
        ];
        open-floating = true;
      }
    ];
  };

  custom.persist = {
    home = {
      directories = [
        # folder preferences such as view mode and sort order
        ".local/share/gvfs-metadata"
      ];
      cache.directories = [
        # thumbnail cache
        ".cache/thumbnails"
      ];
    };
  };
}
