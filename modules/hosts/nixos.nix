{
  inputs,
  config,
  ...
}: let
  inherit (builtins) attrValues;
  inherit (config) flake;
  inherit (inputs) nixpkgs;

  nixMods = [
    inputs.dankMaterialShell.nixosModules.dank-material-shell
    inputs.dankMaterialShell.nixosModules.greeter
    inputs.nix-hazkey.nixosModules.hazkey
    inputs.nix-index-database.nixosModules.nix-index
    inputs.impermanence.nixosModules.impermanence
    inputs.sops-nix.nixosModules.sops
  ];

  hmMods = [];

  linux = mkNixos "x86_64-linux" "nixos";

  mkNixos = system: cls: host: {
    user ? "sumelan",
    defaultNixMods ? [],
    defaultHmMods ? [],
  }: let
    specialArgs = {inherit user;};
  in
    nixpkgs.lib.nixosSystem {
      inherit system specialArgs;
      modules =
        nixMods
        ++ defaultNixMods
        ++ [flake.modules.nixos.common]
        ++ [flake.modules.nixos."hosts/${host}"]
        ++ [flake.modules.nixos."users/${user}"]
        ++ [
          {
            networking.hostName = host;
          }
          inputs.home-manager.nixosModules.home-manager
          (nixpkgs.lib.mkAliasOptionModule ["hm"] ["home-manager" "users" user])
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = specialArgs;
              users.${user}.imports =
                hmMods
                ++ defaultHmMods
                ++ [flake.modules.homeManager."hosts/${host}"]
                ++ [flake.modules.homeManager."users/${user}"];
            };
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
      defaultNixMods = attrValues {
        inherit
          (inputs.nixos-hardware.nixosModules)
          chuwi-minibook-x
          ;
      };
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
