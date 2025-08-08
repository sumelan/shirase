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
    enableList = [
      "cyanrip"
      "foliate"
      "freetube"
      "neovim"
      "obs-studio"
      "protonapp"
      "rmpc"
    ];
    disableList = [
      "wlsunset"
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
    // lib.genAttrs enableList (_name: {
      enable = true;
    })
    // lib.genAttrs disableList (_name: {
      enable = false;
    });
}
