{lib, ...}: let
  inherit
    (lib)
    genAttrs
    ;
in {
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

  stylix = {
    cursor.size = 32;
    fonts.sizes = {
      applications = 13;
      terminal = 13;
      desktop = 13;
      popups = 12;
    };
  };

  programs.noctalia-shell.settings = {
    ui.monitorsScaling = [
      {
        name = "eDP-1";
        scale = 1.0;
      }
    ];
  };

  custom = let
    enableList = [
      "cyanrip"
      "helix"
      "obs-studio"
      "protonapp"
      "rmpc"
      "spotify"
      "youtube-tui"
    ];

    disableList = [
    ];
  in
    genAttrs enableList (_name: {
      enable = true;
    })
    // genAttrs disableList (_name: {
      enable = false;
    });
}
