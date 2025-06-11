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
        inverted-page-curl = { }; # default value
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
