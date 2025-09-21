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
    enableList = [
      "cyanrip"
      "foliate"
      "freetube"
      "noctalia"
      "obs-studio"
      "protonapp"
      "rmpc"
      "spotify"
    ];

    disableList = [
    ];
  in
    {
      stylix = {
        cursor = {
          package = pkgs.capitaine-cursors-themed;
          name = "Capitaine Cursors (Nord)";
        };
        icons = {
          package = pkgs.papirus-nord.override {
            accent = "polarnight3";
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
