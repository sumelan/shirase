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

  # theme
  custom = let
    enableList = [
      "cyanrip"
      "foliate"
      "freetube"
      "helix"
      "obs-studio"
      "protonapp"
    ];
    disableList = [
      "wlsunset"
    ];
  in
    {
      stylix = {
        cursor = {
          package = pkgs.custom.qogir-cursors.override {
            themeVariants = ["Manjaro"];
          };
          name = "dist-Manjaro-Dark";
        };
        icons = {
          package = pkgs.qogir-icon-theme.overrideAttrs {
            colorVariants = ["dark"]; # default is all
            themeVariants = ["manjaro"]; # default is all
          };
          dark = "Qogir-Manjaro-Dark";
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
