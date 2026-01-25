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
    inputs.impermanence.nixosModules.impermanence
    inputs.sops-nix.nixosModules.sops
  ];

  hmMods = [
    inputs.dankMaterialShell.homeModules.dank-material-shell
    inputs.danksearch.homeModules.dsearch
    inputs.nix-hazkey.homeModules.hazkey
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
        ++ [flake.modules.nixos.overlay]
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
