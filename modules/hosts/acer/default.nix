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
      inputs.nixos-hardware.nixosModules.common-pc-laptop
      inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
      inputs.nixos-hardware.nixosModules.common-cpu-intel
    ];

  hmMods = [
    inputs.dankMaterialShell.homeModules.dank-material-shell
    inputs.nix-index-database.homeModules.nix-index
  ];
in {
  flake.modules.nixos.host_acer = {
    imports =
      nixMods
      ++ [config.flake.modules.nixos.hardware_acer]
      ++ [
        {
          networking.hostId = "22fe2870";
        }
      ]
      ++ (with config.flake.modules.nixos; [
        default
        laptop
      ])
      ++ [
        {
          hm.imports =
            hmMods
            ++ [
              {
                flake.modules.monitors = {
                  "eDP-1" = {
                    isMain = true;
                    scale = 1.0;
                    mode = {
                      width = 1920;
                      height = 1200;
                      refresh = 60.0;
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
            ]);
        }
      ];
  };
}
