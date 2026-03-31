_: let
  inherit (builtins) attrValues;
in {
  flake.modules.nixos.gui = {
    config,
    pkgs,
    ...
  }: {
    environment.systemPackages = attrValues {
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
      mime.defaultApplications = {
        "inode/directory" = "org.gnome.Nautilus.desktop";
        "application/zip" = "org.gnome.FileRoller.desktop";
        "application/vnd.rar" = "org.gnome.FileRoller.desktop";
        "application/x-7z-compressed" = "org.gnome.FileRoller.desktop";
        "application/x-bzip2-compressed-tar" = "org.gnome.FileRoller.desktop";
        "application/x-tar" = "org.gnome.FileRoller.desktop";
      };
    };

    custom = {
      # NOTE: to find a setting value, run `dconf watch /` in terminal
      dconf.settings = {
        # fix open in terminal
        "org/gnome/desktop/applications/terminal" = {
          exec = "xdg-terminal-exec";
        };
        "org/gnome/nautilus/preferences" = {
          default-folder-viewer = "list-view";
          show-create-link = true;
          show-delete-permanently = true;
        };
      };

      gtk.bookmarks = let
        homeDir = config.hm.home.homeDirectory;
        flakePath = "/persist${homeDir}/Projects/shirase";
      in
        [
          "${homeDir}/Documents"
          "${homeDir}/Downloads"
          "${homeDir}/Music"
          "${homeDir}/Videos"
          "${homeDir}/Pictures/Screenshots"
          "${homeDir}/Pictures/Wallpapers"
        ]
        ++ [
          "${flakePath} Shirase"
          "/persist Persist"
        ];
    };

    custom.fileSystem = {
      persist.home.directories = [
        ".local/share/gvfs-metadata" # folder preferences such as view mode and sort order
      ];
      cache.home.directories = [
        ".cache/thumbnails" # thumbnail cache
      ];
    };
  };
}
