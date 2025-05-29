{ pkgs, ... }:
{
  monitors = {
    "HDMI-A-1" = {
      isMain = true;
      scale = 1.00;
      mode = {
        width = 2560;
        height = 1440;
        refresh = 59.951;
      };
      position = {
        x = 0;
        y = 0;
      };
      rotation = 0;
    };
    "DP-1" = {
      scale = 1.0;
      mode = {
        width = 2560;
        height = 1440;
        refresh = 59.951;
      };
      position = {
        x = 2560;
        y = 0;
      };
      rotation = 0;
    };
  };

  custom = {
    # theme
    stylix = {
      icon = {
        package = pkgs.magnetic-catppuccin-gtk;
        darkName = "Catppuccin-GTK-Dark";
        lightName = "Catppuccin-GTK-Dark"; # seems not contain light-theme icons;
      };
    };

    brave.enable = false;
    cyanrip.enable = true;
    ebook.enable = true;
    inkscape.enable = true;
    krita.enable = true;
    thunderbird.enable = false;
  };
}
