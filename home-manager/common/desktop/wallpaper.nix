{ user, ... }:
{
  services.wpaperd = {
    enable = true;
    settings = {
      default = {
        duration = "12m";
        mode = "center";
        sorting = "random";
      };
      default.transition = {
        stereo-viewer = { }; # default value
      };
      # using regex
      "re:LG" = {
        path = "/home/${user}/Pictures/Wallpapers";
      };
      "re:eDP-1" = {
        path = "/home/${user}/Pictures/Wallpapers";
      };
    };
  };
}
