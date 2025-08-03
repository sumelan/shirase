{ pkgs, ... }:
{
  monitors = {
    "HDMI-A-1" = {
      isMain = true;
      scale = 1.5;
      mode = {
        width = 2560;
        height = 1600;
        refresh = 60.000;
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
        package = pkgs.catppuccin-cursors.frappeDark;
        name = "catppuccin-frappe-dark-cursors";
      };
      icons = {
        package = pkgs.catppuccin-papirus-folders.override {
          flavor = "frappe";
          accent = "sapphire";
        };
        dark = "Papirus-Dark";
      };
    };
    niri.xwayland.enable = true;
  };
}
