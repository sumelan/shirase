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
    ++ [
      inputs.nixos-hardware.nixosModules.common-pc
      inputs.nixos-hardware.nixosModules.common-pc-ssd
      inputs.nixos-hardware.nixosModules.common-cpu-amd
      inputs.nixos-hardware.nixosModules.common-gpu-amd
    ];

  hmMods = [
    inputs.dankMaterialShell.homeModules.dank-material-shell
    inputs.nix-index-database.homeModules.nix-index
  ];
in {
  flake.modules.generic.host_sakura = {
    imports =
      nixMods
      ++ [config.flake.modules.nixos.hardware_sakura]
      ++ [
        {
          networking.hostId = "b5e8f0be";

          services.syncthing = {
            key = "/run/secrets/syncthing/sakura-key";
            cert = "/run/secrets/syncthing/sakura-cert";
            settings = {
              devices = {
                "minibookx" = {id = "LTAE56R-6ARZAXL-JK4KL6B-IHVTITS-AEL3TCQ-JR4ZNQQ-52QHVU2-7UU7SQI";};
              };
              folders = {
                "Documents" = {
                  devices = ["minibookx"];
                };
                "Music" = {
                  devices = ["minibookx"];
                };
                "MPD" = {
                  devices = ["minibookx"];
                };
                "Euphonica" = {
                  devices = ["minibookx"];
                };
                "Wallpapers" = {
                  devices = ["minibookx"];
                };
              };
            };
          };
          custom.hdds = {
            westernDigital = true;
            ironWolf = true;
          };
        }
      ]
      ++ (with config.flake.modules.nixos; [
        default
        hdds
        logitech
        sops-nix
        steam
        syncthing
        qmk
      ])
      ++ [
        {
          hm.imports =
            hmMods
            ++ [
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
            ++ (with config.flake.modules.homeManager; [
              default
              foliate
              helium
              kdeconnect
              obs-studio
              protonapp
              vlc
              youtube-tui
            ]);
        }
      ];
  };
}
