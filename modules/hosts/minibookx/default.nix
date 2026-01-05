{config, ...}: let
  inherit (config) flake;
in {
  flake.modules = {
    nixos.minibookx = _: {
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
          hardware_minibookx
          chuwi-minibook-x
          laptop
          sops-nix
          syncthing
          syncthing_minibookx
        ]);
    };

    homeManager.minibookx = _: {
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
                rotation = 0;
              };
            };
          }
        ]
        ++ (with flake.modules.homeManager; [
          default
          foliate
          helium
          kdeconnect
          protonapp
          rmpc
          youtube-tui
        ]);
    };
  };
}
