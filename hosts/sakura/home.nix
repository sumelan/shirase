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
        name = "Capitaine Cursors (Gruvbox)";
      };
      icon = {
        package = pkgs.gruvbox-plus-icons.override {
          # Supported colors: black blue caramel citron firebrick gold green grey highland jade lavender
          # lime olive orange pistachio plasma pumpkin purple red rust sapphire tomato violet white yellow
          folder-color = "lime";
        };
        darkName = "Gruvbox-Plus-Dark";
      };
    };

    xwayland.enable = false;

    brave.enable = false;
    cyanrip.enable = true;
    foliate.enable = true;
    helix.enable = false;
    krita.enable = false;
    thunderbird.enable = false;
  };
}
