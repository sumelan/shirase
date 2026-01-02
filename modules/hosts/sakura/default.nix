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
      ++ [
        {
          networking.hostId = "b5e8f0be";
        }
      ]
      ++ (with config.flake.modules.nixos; [
        default
        hardware_sakura
        hdds
        logitech
        sops-nix
        steam
        syncoid
        syncoid_sakura
        syncthing
        syncthing_sakura
        qmk
      ])
      ++ [
        {
          custom.hdds = {
            westernDigital = true;
            ironWolf = true;
          };
        }
      ]
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
              helium
              kdeconnect
              obs-studio
              rmpc
              protonapp
              vlc
              youtube-tui
            ]);
        }
      ];
  };
}
