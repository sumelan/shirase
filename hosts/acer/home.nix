{ pkgs, ... }:
{
  monitors = {
    "eDP-1" = {
      isMain = true;
      scale = 1.0;
      mode = {
        width = 1920;
        height = 1200;
        refresh = 60.0;
      };
      position = {
        x = 0;
        y = 0;
      };
      rotation = 0;
    };
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
    thunderbird.enable = true;
  };
}
