{ config, ... }:
{
  services.wpaperd = {
    enable = true;
    settings = {
      default = {
        duration = "12m";
        mode = "center";
        sorting = "random";
        offset = 0.2;
        transition = {
          ripple = { }; # keep blank to use on default values
        };
      };
      # using regex
      "re:${config.lib.monitors.mainMonitorName}" = {
        path = "${config.xdg.userDirs.pictures}/Wallpapers";
      };
    };
  };
  programs.niri.settings.layer-rules = [
    {
      matches = [ { namespace = "wpaperd"; } ];
      place-within-backdrop = true;
    }
  ];
}
