{lib, ...}: let
  inherit (lib) genAttrs;
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
    "HDMI-A-2" = {
      scale = 1.0;
      mode = {
        width = 2560;
        height = 1600;
        refresh = 60.0;
      };
      position = {
        x = 2560;
        y = 0;
      };
      rotation = 0;
    };
  };

  custom = let
    enableList = [
      "cyanrip"
      "kdeconnect"
      "librewolf"
      "obs-studio"
      "protonapp"
      "rmpc"
      "spicetify-nix"
      "spotify-player"
      "youtube-tui"
    ];

    disableList = [
    ];
  in
    {
      niri.xwayland.enable = true;
    }
    // genAttrs enableList (_name: {enable = true;})
    // genAttrs disableList (_name: {enable = false;});
}
