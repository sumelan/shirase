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
    "HDMI-A-1" = {
      isMain = true;
      scale = 1.5;
      mode = {
        width = 3840;
        height = 2160;
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
        "brave"
        "cyanrip"
        "euphonica"
        "foliate"
        "freetube"
        "helix"
        "obs-studio"
        "protonapp"
      ]
      ++ ["fuzzel" "noctalia" "swayidle"];

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
      niri.xwayland.enable = false;
    }
    // genAttrs enableList (_name: {
      enable = true;
    })
    // genAttrs disableList (_name: {
      enable = false;
    });
}
