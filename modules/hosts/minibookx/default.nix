{config, ...}: let
  inherit (config) flake;
in {
  flake.modules = {
    nixos."hosts/minibookx" = {pkgs, ...}: {
      imports =
        [
          {
            networking.hostId = "56895d2b";

            programs.ssh = {
              extraConfig = ''
                Host sakura
                  HostName 192.168.68.62
                  Port 22
                  User root
              '';
            };

            custom = {
              hardware.monitors = {
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
                  rotation = 270;
                };
              };

              programs.niri.screenshot.host = "minibookx";

              # hinted font: for lower or equal than 1080p
              fonts.packages = [pkgs.maple-mono.NF];
            };
          }
        ]
        ++ (with flake.modules.nixos;
          [
            default
            hardware-minibookx
            chuwi-minibook-x
            laptop
            gui
            sops-nix
            syncthing
            syncthing-minibookx
          ]
          ++ [
            hjem-default
            hjem-gui
            hjem-ebook
            hjem-kdeconnect
            hjem-protonapp
            hjem-rmpc
          ]);
    };
  };
}
