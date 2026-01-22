{config, ...}: let
  inherit (config) flake;
in {
  flake.modules = {
    nixos."hosts/sakura" = _: {
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
          minisforum
          hdds
          kdeconnect
          logitech
          sops-nix
          steam
          syncoid
          syncoid-sakura
          syncthing
          syncthing-sakura
          qmk
        ]);
    };

    homeManager."hosts/sakura" = {pkgs, ...}: {
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
            custom = {
              # unhinted font: for high resolution screen
              fonts.packages = [pkgs.maple-mono.NF-unhinted];
              niri = {
                xwayland = true;
                screenshot.host = "sakura";
              };
            };
          }
        ]
        ++ (with flake.modules.homeManager; [
          default
          dissent
          foliate
          obs-studio
          protonapp
          rmpc
          vlc
          youtube-tui
        ]);
    };
  };
}
