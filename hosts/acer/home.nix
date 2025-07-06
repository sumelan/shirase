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
    helix.enable = true;
    thunderbird.enable = true;
  };
}
