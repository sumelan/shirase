{pkgs, ...}: {
  monitors = {
    "HDMI-A-1" = {
      isMain = true;
      scale = 1.5;
      mode = {
        width = 2560;
        height = 1600;
        refresh = 60.000;
      };
      position = {
        x = 0;
        y = 0;
      };
      rotation = 0;
    };
  };

  custom = {
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
  };
}
