{
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
}
