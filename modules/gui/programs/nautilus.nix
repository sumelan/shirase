{lib, ...}: let
  inherit (lib) getExe;
in {
  flake.modules.homeManager.default = {
    config,
    pkgs,
    ...
  }: {
    home.packages = builtins.attrValues {
      inherit
        (pkgs)
        nautilus
        file-roller
        libheif # HEIC image preview
        p7zip-rar # support for encrypted archives
        webp-pixbuf-loader # for webp thumbnails
        ;
    };

    xdg = {
      # fix opening terminal for nautilus by using xdg-terminal-exec spec
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
      flakePath = "/persist${homeDir}/Projects/shirase";
    in
      [
        "file://${homeDir}/Documents"
        "file://${homeDir}/Downloads"
        "file://${homeDir}/Music"
        "file://${homeDir}/Videos"
        "file://${homeDir}/Pictures/Screenshots"
        "file://${homeDir}/Pictures/Wallpapers"
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
      "org/gnome/nautilus/preferences" = {
        default-folder-viewer = "list-view";
        show-create-link = true;
        show-delete-permanently = true;
      };
    };

    custom = {
      persist.home.directories = [
        ".local/share/gvfs-metadata" # folder preferences such as view mode and sort order
      ];
      cache.home.directories = [
        ".cache/thumbnails" # thumbnail cache
      ];
    };
  };
}
