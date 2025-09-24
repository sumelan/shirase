{
  lib,
  pkgs,
  self,
  ...
}: let
  inherit
    (lib)
    genAttrs
    ;
in {
  monitors = {
    "DP-1" = {
      isMain = true;
      scale = 1.25;
      mode = {
        width = 1920;
        height = 1080;
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
    enableList = [
      "freetube"
      "noctalia"
      "rmpc"
      "spotify"
    ];

    disableList = [
    ];
  in
    {
      stylix = {
        cursor = {
          package = self.packages.${pkgs.system}.everforest-cursors;
          name = "everforest-cursors";
        };
        icons = {
          package = pkgs.everforest-gtk-theme;
          dark = "Everforest-Dark";
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
