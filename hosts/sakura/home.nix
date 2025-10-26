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
    enableList =
      [
        "cyanrip"
        "helium"
        "kdeconnect"
        "obs-studio"
        "protonapp"
        "rmpc"
        "spicetify-nix"
        "spotify-player"
        "youtube-tui"
      ]
      ++ [
        "astal-shell"
        "dunst"
        "hypridle"
        "hyprlock"
        "rofi"
        "swww"
      ];

    disableList = [
      "noctalia"
      "swayidle"
    ];
  in
    genAttrs enableList (_name: {enable = true;})
    // genAttrs disableList (_name: {enable = false;});
}
