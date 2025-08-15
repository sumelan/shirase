{
  lib,
  config,
  user,
  ...
}: let
  wallpaperDir = "${config.xdg.userDirs.pictures}/Wallpapers";
in {
  options.custom = {
    wallpaper.enable =
      lib.mkEnableOption "Wallpapers"
      // {
        default = true;
      };
  };

  config = lib.mkIf config.custom.wallpaper.enable {
    # create wallpaperDir on boot if not exist
    systemd.user.tmpfiles.rules = lib.custom.tmpfiles.mkCreateAndCleanup wallpaperDir {
      inherit user;
      group = "users";
    };

    services.wpaperd = {
      enable = true;
      settings = {
        default = {
          duration = "12m";
          mode = "center";
          sorting = "random";
          recursive = true;
          offset = 0.1;
        };
        default.transition = {
          ripple = {};
        };
        # using regex
        "re:${config.lib.monitors.mainMonitorName}" = {
          path = wallpaperDir;
        };
      };
    };

    programs.niri.settings.layer-rules = [
      {
        matches = lib.singleton {
          namespace = "wpaperd";
        };
        place-within-backdrop = true;
      }
    ];
  };
}
