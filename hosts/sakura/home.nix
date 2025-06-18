{ pkgs, ... }:
{
  monitors = {
    "HDMI-A-1" = {
      isMain = true;
      scale = 1.50;
      mode = {
        width = 3840;
        height = 2160;
        refresh = 60.000;
      };
      position = {
        x = 0;
        y = 0;
      };
      rotation = 0;
    };
    #   "DP-1" = {
    #     scale = 1.0;
    #     mode = {
    #       width = 2560;
    #       height = 1440;
    #       refresh = 59.951;
    #     };
    #     position = {
    #       x = 0;
    #       y = 0;
    #     };
    #     rotation = 0;
    #   };
  };

  custom = {
    # theme
    stylix = {
      cursor = {
        package = pkgs.capitaine-cursors-themed;
        name = "Capitaine Cursors (Nord)";
      };
      icon = {
        package = pkgs.papirus-nord.override {
          accent = "frostblue3";
        };
        darkName = "Papirus-Dark";
        lightName = "Papirus-Light";
      };
    };

    xwayland.enable = false;

    brave.enable = true;
    cyanrip.enable = true;
    foliate.enable = true;
    krita.enable = false;
    thunderbird.enable = false;
  };
}
