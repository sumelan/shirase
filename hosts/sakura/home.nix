{ pkgs, ... }:
{
  monitors = {
    "HDMI-A-1" = {
      isMain = true;
      scale = 1.50;
      mode = {
        width = 3840;
        height = 2160;
        refresh = 60.00;
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
        name = "Capitaine Cursors (Palenight)";
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
    ebook.enable = true;
    krita.enable = false;
    thunderbird.enable = false;
  };
}
