{config, ...}: let
  inherit (config) flake;
in {
  flake.modules = {
    nixos."hosts/minibookx" = _: {
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
          }
        ]
        ++ (with flake.modules.nixos; [
          default
          hardware-minibookx
          chuwi-minibook-x
          kdeconnect
          laptop
          sops-nix
          syncthing
          syncthing-minibookx
        ]);
    };

    homeManager."hosts/minibookx" = {pkgs, ...}: {
      imports =
        [
          {
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
                rotation = 270;
              };
            };
            custom = {
              # hinted font: for lower or equal than 1080p
              fonts.packages = [pkgs.maple-mono.NF];
              niri.screenshot.host = "minibookx";
            };
          }
        ]
        ++ (with flake.modules.homeManager; [
          default
          foliate
          pear-desktop
          protonapp
          rmpc
          youtube-tui
        ]);
    };
  };
}
