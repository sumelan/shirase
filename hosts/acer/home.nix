{ lib, pkgs, ... }:
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

  # theme
  custom =
    let
      enableList = [
        "cyanrip"
        "foliate"
        "freetube"
        "obs-studio"
        "protonapp"
      ];
      disableList = [
        "helix"
        "wlsunset"
      ];
    in
    {
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
    }
    // lib.genAttrs enableList (_name: {
      enable = true;
    })
    // lib.genAttrs disableList (_name: {
      enable = false;
    });
}
