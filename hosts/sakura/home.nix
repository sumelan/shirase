{
  lib,
  pkgs,
  ...
}: {
  monitors = {
    "DP-1" = {
      isMain = true;
      scale = 1.0;
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
      "rmpc"
      "wlsunset"
    ];
    disableList = [
      "neovim"
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
      niri.xwayland.enable = true;
    }
    // lib.genAttrs enableList (_name: {
      enable = true;
    })
    // lib.genAttrs disableList (_name: {
      enable = false;
    });
}
