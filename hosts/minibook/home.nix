{lib, ...}: let
  inherit (lib) genAttrs;
in {
  monitors = {
    "DSI-1" = {
      isMain = true;
      scale = 1.35;
      mode = {
        width = 1200;
        height = 1920;
        refresh = 50.002;
      };
      position = {
        x = 0;
        y = 0;
      };
      rotation = 270;
    };
  };

  programs.niri.settings.input = {
    tablet = {
      enable = true;
      map-to-output = "DSI-1";
    };
    touch = {
      enable = true;
      map-to-output = "DSI-1";
    };
  };

  custom = let
    enableList = [
      "kdeconnect"
      "noctalia"
      "protonapp"
      "rmpc"
      "spicetify-nix"
      "spotify-player"
      "youtube-tui"
    ];

    disableList = [
    ];
  in
    genAttrs enableList (_name: {enable = true;})
    // genAttrs disableList (_name: {enable = false;});
}
