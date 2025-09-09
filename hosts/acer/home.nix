{
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    genAttrs
    ;
in {
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

  custom = let
    enableList =
      [
        "cyanrip"
        "euphonica"
        "freetube"
        "protonapp"
      ]
      ++ ["niri-caelestia" "swayosd"];

    disableList = [
      "dunst"
      "hypridle"
      "hyprlock"
      "rofi"
      "wpaperd"
      "waybar"
    ];
  in
    {
      stylix = {
        cursor = {
          package = pkgs.custom.colloid-pastel-cursors;
          name = "dist-dark";
        };
        icons = {
          package = pkgs.custom.colloid-pastel-icons;
          dark = "Colloid-Pastel-Dark";
        };
      };
    }
    // genAttrs enableList (_name: {
      enable = true;
    })
    // genAttrs disableList (_name: {
      enable = false;
    });
}
