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
        "cyanrip"
        "euphonica"
        "foliate"
        "freetube"
        "obs-studio"
        "protonapp"
        "spotify"
      ]
      ++ ["dms" "swayidle"];

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
          package = pkgs.catppuccin-cursors.frappeLight;
          name = "catppuccin-frappe-light-cursors";
        };
        icons = {
          package = pkgs.catppuccin-papirus-folders.override {
            flavor = "frappe";
            accent = "lavender";
          };
          dark = "Papirus-Dark";
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
