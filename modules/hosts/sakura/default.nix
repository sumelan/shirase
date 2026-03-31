{config, ...}: let
  inherit (config) flake;
in {
  flake.modules = {
    nixos."hosts/sakura" = {pkgs, ...}: {
      imports =
        [
          {
            networking.hostId = "b5e8f0be";

            custom = {
              hardware = {
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

                hdds = {
                  westernDigital = true;
                  ironWolf = true;
                };
              };

              # unhinted font: for high resolution screen
              fonts.packages = [pkgs.maple-mono.NF-unhinted];

              programs = {
                btop.rocmSupport = true;
                niri = {
                  xwayland = true;
                  screenshot.host = "sakura";
                };
              };
            };
          }
        ]
        ++ (
          with flake.modules.nixos;
            [
              default
              hardware-sakura
              minisforum
              gui
              audiobookshelf
              hdds
              logitech
              sops-nix
              steam
              syncoid
              syncoid-sakura
              syncthing
              syncthing-sakura
              qmk
            ]
            ++ [
              hjem-default
              hjem-gui
              hjem-bluray
              hjem-cd
              hjem-ebook
              hjem-kdeconnect
              hjem-obs
              hjem-protonapp
              hjem-rmpc
            ]
        );
    };
  };
}
