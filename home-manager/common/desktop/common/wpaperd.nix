{
  lib,
  config,
  user,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    singleton
    ;

  inherit
    (lib.custom.tmpfiles)
    mkCreateAndCleanup
    ;

  wallpaperDir = "${config.xdg.userDirs.pictures}/Wallpapers";
in {
  options.custom = {
    wpaperd.enable = mkEnableOption "Wallpapers" // {default = true;};
  };

  config = mkIf config.custom.wpaperd.enable {
    # create wallpaperDir on boot if not exist
    systemd.user.tmpfiles.rules = mkCreateAndCleanup wallpaperDir {
      inherit user;
      group = "users";
    };

    services.wpaperd = {
      enable = true;
      settings = {
        default = {
          duration = "15m";
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
        matches = singleton {
          namespace = "wpaperd";
        };
        place-within-backdrop = false;
      }
    ];
  };
}
