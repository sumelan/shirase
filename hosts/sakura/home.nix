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
  };

  custom = let
    enableList = [
      "foliate"
      "helium"
      "kdeconnect"
      "obs-studio"
      "protonapp"
      "vlc"
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
