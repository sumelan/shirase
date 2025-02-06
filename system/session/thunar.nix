{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.custom = with lib; {
    thunar.enable = mkEnableOption "thunar";
  };

  config = lib.mkIf config.custom.thunar.enable {
    programs.thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-volman
        thunar-archive-plugin
        thunar-media-tags-plugin
      ];
    };
    services = {
      gvfs.enable = true;
      tumbler.enable = true;
    };
    environment.systemPackages = [
      pkgs.ffmpegthumbnailer
      pkgs.bign-handheld-thumbnailer
    ];

    hm.xdg = {
      mimeApps.defaultApplications = {
        "inode/directory" = "thunar.desktop";
      };

      configFile =  {
          "mimeapps.list".force = true;
      };
    };

    custom.persist = {
      home.directories = [
        .config/Thunar
        .config/xfce4
      ];
    };
  };
}
