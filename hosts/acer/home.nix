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
    maomao.enable = true;
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

    xwayland.enable = false;

    brave.enable = false;
    cyanrip.enable = true;
    foliate.enable = true;
    helix.enable = false;
    thunderbird.enable = true;
  };
}
