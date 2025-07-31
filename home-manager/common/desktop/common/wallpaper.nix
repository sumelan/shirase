{
  lib,
  config,
  user,
  ...
}:
let
  wallpaperDir = "${config.xdg.userDirs.pictures}/Wallpapers";
in
{
  # create wallpaperDir on boot if not exist
  systemd.user.tmpfiles.rules = lib.custom.nixos.mkCreate wallpaperDir {
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
        ripple = { };
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
}
