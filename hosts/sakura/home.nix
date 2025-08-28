{
  lib,
  pkgs,
  ...
}: {
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
    "HDMI-A-2" = {
      scale = 1.0;
      mode = {
        width = 2560;
        height = 1600;
        refresh = 60.0;
      };
      position = {
        x = 0;
        y = 1440;
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
        "helix"
        "obs-studio"
        "protonapp"
        "rmpc"
      ]
      ++ ["fuzzel" "noctalia" "swayidle" "swayosd"];

    disableList = [
      "dunst"
      "hypridle"
      "hyprlock"
      "rofi"
      "wallpaper"
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
    // lib.genAttrs enableList (_name: {
      enable = true;
    })
    // lib.genAttrs disableList (_name: {
      enable = false;
    });
}
