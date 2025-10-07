{lib, ...}: let
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

  stylix = {
    cursor.size = 32;
    fonts.sizes = {
      applications = 13;
      terminal = 13;
      desktop = 13;
      popups = 12;
    };
  };

  custom = let
    enableList = [
      "rmpc"
    ];

    disableList = [
    ];
  in
    {
      niri.xwayland.enable = false;
    }
    // genAttrs enableList (_name: {
      enable = true;
    })
    // genAttrs disableList (_name: {
      enable = false;
    });
}
