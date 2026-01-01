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
      ++ (with config.flake.modules.nixos; [
        hardware_minibookx
        chuwi-minibook-x
      ])
      ++ [
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
      ++ (with config.flake.modules.nixos; [
        default
        laptop
        sops-nix
        syncthing
        syncthing_minibookx
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
