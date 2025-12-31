{
  config,
  inputs,
  ...
}: let
  nixMods =
    [
      inputs.dankMaterialShell.nixosModules.dank-material-shell
      inputs.dankMaterialShell.nixosModules.greeter
      inputs.impermanence.nixosModules.impermanence
      inputs.niri-flake.nixosModules.niri
      inputs.sops-nix.nixosModules.sops
    ]
    ++ [inputs.nix-chuwi-minibook-x.nixosModules.default];

  hmMods = [
    inputs.dankMaterialShell.homeModules.dank-material-shell
    inputs.nix-index-database.homeModules.nix-index
  ];
in {
  flake.modules.generic.host_minibookx = {
    imports =
      nixMods
      ++ [config.flake.modules.nixos.hardware_minibookx]
      ++ [
        {
          networking.hostId = "56895d2b";

          hardware.chuwi-minibook-x = {
            tabletMode.enable = true;
            autoDisplayRotation = {
              enable = true;
              commands = {
                normal = ''niri msg output "DSI-1" transform 90'';
                rightUp = ''niri msg output "DSI-1" transform normal'';
                bottomUp = ''niri msg output "DSI-1" transform 270'';
                leftUp = ''niri msg output "DSI-1" transform 180'';
              };
            };
          };

          # rotate limine interface
          boot.loader.limine.extraConfig = ''
            interface_rotation: 90
          '';

          programs.ssh = {
            extraConfig = ''
              Host sakura
                HostName 192.168.68.62
                Port 22
                User root
            '';
          };

          services.syncthing = {
            key = "/run/secrets/syncthing/minibookx-key";
            cert = "/run/secrets/syncthing/minibookx-cert";
            settings = {
              devices = {
                "sakura" = {id = "DVKBE2A-EP3TVWL-VMTBIOA-PVGBRML-7JION7K-GVXA6FD-FZ7EAUV-HATEEQS";};
              };
              folders = {
                "Documents" = {
                  devices = ["sakura"];
                };
                "Music" = {
                  devices = ["sakura"];
                };
                "MPD" = {
                  devices = ["sakura"];
                };
                "Euphonica" = {
                  devices = ["sakura"];
                };
                "Wallpapers" = {
                  devices = ["sakura"];
                };
              };
            };
          };
        }
      ]
      ++ (with config.flake.modules.nixos; [
        default
        laptop
        sops-nix
        syncthing
      ])
      ++ [
        {
          hm.imports =
            hmMods
            ++ [
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
            ++ (with config.flake.modules.homeManager; [
              default
              foliate
              helium
              kdeconnect
              protonapp
              youtube-tui
            ]);
        }
      ];
  };
}
