{lib, ...}: let
  inherit (lib) genAttrs;
in {
  monitors = {
    "DSI-1" = {
      isMain = true;
      scale = 1.0;
      mode = {
        width = 1200;
        height = 1920;
        refresh = 50.002;
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
      "protonapp"
      "youtube-tui"
    ];

    disableList = [
    ];
  in
    {
      niri.xwayland.enable = false;
    }
    // genAttrs enableList (_name: {enable = true;})
    // genAttrs disableList (_name: {enable = false;});
}
