{ user, ... }:
{
  services.wpaperd = {
    enable = true;
    settings = {
      default = {
        duration = "12m";
        mode = "center";
        sorting = "random";
        transition = {
          grid-flip = { }; # keep blank to use on default values
        };
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
