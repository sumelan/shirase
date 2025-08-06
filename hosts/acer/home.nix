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
          package = pkgs.nordzy-cursor-theme;
          name = "Nordzy-cursors-white";
        };
        icons = {
          package = pkgs.nordzy-icon-theme.override {
            nordzy-themes = ["cyan"];
          };
          dark = "Nordzy-cyan-dark";
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
