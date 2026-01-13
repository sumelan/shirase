{config, ...}: let
  inherit (config) flake;
in {
  flake.modules = {
    nixos.sakura = _: {
      imports =
        [
          {
            networking.hostId = "b5e8f0be";

            custom.hdds = {
              westernDigital = true;
              ironWolf = true;
            };
          }
        ]
        ++ (with flake.modules.nixos; [
          default
          hardware-sakura
          hdds
          logitech
          opentabletdriver
          sops-nix
          steam
          syncoid
          syncoid-sakura
          syncthing
          syncthing-sakura
          qmk
          valent
        ]);
    };

    homeManager.sakura = _: {
      imports =
        [
          {
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
            custom.niri.xwayland = true;
          }
        ]
        ++ (with flake.modules.homeManager; [
          default
          dissent
          foliate
          helium
          kitty
          krita
          obs-studio
          protonapp
          rmpc
          vlc
          youtube-tui
        ]);
    };
  };
}
