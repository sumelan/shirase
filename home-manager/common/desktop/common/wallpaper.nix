{
  lib,
  config,
  ...
}:
{
  services.wpaperd = {
    enable = true;
    settings = {
      default = {
        duration = "12m";
        mode = "center";
        sorting = "random";
        recursive = true;
        offset = 0.2;
      };
      default.transition = {
        ripple = { };
      };
      # using regex
      "re:${config.lib.monitors.mainMonitorName}" = {
        path = "${config.xdg.userDirs.pictures}/Wallpapers";
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
