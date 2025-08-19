{
  lib,
  pkgs,
  ...
}: {
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
        "foliate"
        "freetube"
        "helix"
        "protonapp"
        "rmpc"
      ]
      ++ ["fuzzel" "noctalia-shell" "swayidle"];
    disableList =
      [
        "obs-studio"
        "wlsunset"
      ]
      ++ [
        "dunst"
        "hypridle"
        "hyprlock"
        "rofi"
        "swayosd"
        "wallpaper"
        "waybar"
      ];
  in
    {
      stylix = {
        cursor = {
          package = pkgs.capitaine-cursors-themed;
          name = "Capitaine Cursors (Gruvbox)";
        };
        icons = {
          package = pkgs.gruvbox-plus-icons.override {
            folder-color = "lime";
          };
          dark = "Gruvbox-Plus-Dark";
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
