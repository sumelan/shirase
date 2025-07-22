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
        package = pkgs.catppuccin-cursors.frappeDark;
        name = "catppuccin-frappe-dark-cursors";
      };
      icon = {
        package = pkgs.catppuccin-papirus-folders.override {
          flavor = "frappe";
          accent = "sapphire";
        };
        darkName = "Papirus-Dark";
        lightName = "Papirus-Light";
      };
    };

    brave.enable = false;
    cyanrip.enable = true;
    foliate.enable = true;
    freetube.enable = true;
    helix.enable = false;
    thunderbird.enable = false;
    wlsunset.enable = true;
  };
}
