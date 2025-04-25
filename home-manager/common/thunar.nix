{ pkgs, ... }:
{
  home.packages = with pkgs; [
    p7zip-rar # support for encrypted archives
    webp-pixbuf-loader # for webp thumbnails
    xdg-terminal-exec
  ];

  xdg = {
    # fix mimetype associations
    mimeApps.defaultApplications = {
      "inode/directory" = "thunar.desktop";
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

  programs.niri.settings.window-rules = [
    {
      matches = [ { app-id = "^(thunar)$"; } ];
      open-floating = true;
      default-column-width.proportion = 0.4;
      default-window-height.proportion = 0.4;
    }
  ];

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
