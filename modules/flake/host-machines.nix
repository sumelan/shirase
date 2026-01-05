{
  inputs,
  config,
  ...
}: let
  inherit (config) flake;
  inherit (builtins) attrValues;
  inherit (inputs) nixpkgs;

  nixMods = [
    inputs.dankMaterialShell.nixosModules.dank-material-shell
    inputs.dankMaterialShell.nixosModules.greeter
    inputs.impermanence.nixosModules.impermanence
    inputs.niri-flake.nixosModules.niri
    inputs.sops-nix.nixosModules.sops
  ];

  hmMods = [
    inputs.dankMaterialShell.homeModules.dank-material-shell
    inputs.nix-index-database.homeModules.nix-index
  ];

  linux = mkNixos "x86_64-linux" "nixos";

  mkNixos = system: cls: host: {
    user ? "sumelan",
    defaultNixMods ? [],
    defaultHmMods ? [],
  }: let
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    specialArgs = {inherit user;};
  in
    nixpkgs.lib.nixosSystem {
      inherit system pkgs specialArgs;
      modules =
        nixMods
        ++ defaultNixMods
        ++ [flake.modules.nixos.${host}]
        ++ [flake.modules.nixos.${user}]
        ++ [flake.modules.nixos.overlay]
        ++ [
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = specialArgs;
              users.${user}.imports =
                hmMods
                ++ defaultHmMods
                ++ [flake.modules.homeManager.${host}]
                ++ [flake.modules.homeManager.${user}];
            };
          }
          (nixpkgs.lib.mkAliasOptionModule ["hm"] ["home-manager" "users" user])
          {
            networking.hostName = host;
          }
        ];
    };
in {
  flake.nixosConfigurations = {
    acer = linux "acer" {
      defaultNixMods = attrValues {
        inherit
          (inputs.nixos-hardware.nixosModules)
          common-pc-laptop
          common-pc-laptop-ssd
          common-cpu-intel
          ;
      };
    };
    minibookx = linux "minibookx" {
      defaultNixMods = [
        inputs.nix-chuwi-minibook-x.nixosModules.default
      ];
    };
    sakura = linux "sakura" {
      defaultNixMods = attrValues {
        inherit
          (inputs.nixos-hardware.nixosModules)
          common-pc
          common-pc-ssd
          common-cpu-amd
          common-gpu-amd
          ;
      };
    };
  };
}
