{
  inputs,
  config,
  ...
}: let
  inherit (builtins) attrValues;
  inherit (inputs) nixpkgs;
  inherit (config) flake;
  defaultMods = [
    inputs.dankMaterialShell.nixosModules.dank-material-shell
    inputs.dankMaterialShell.nixosModules.greeter
    inputs.hjem.nixosModules.default
    inputs.impermanence.nixosModules.impermanence
    inputs.niri-nix.nixosModules.default
    inputs.nix-hazkey.nixosModules.hazkey
    inputs.nix-index-database.nixosModules.nix-index
    inputs.sops-nix.nixosModules.sops
  ];

  linux = mkNixos "x86_64-linux" "nixos";

  mkNixos = system: cls: host: {
    user ? "sumelan",
    dotfile ? "/persist/home/${user}/Projects/shirase",
    extraMods ? [],
  }: let
    specialArgs = {inherit user dotfile;};
  in
    nixpkgs.lib.nixosSystem {
      inherit specialArgs;
      modules =
        defaultMods
        ++ extraMods
        ++ [flake.modules.nixos.hjem]
        ++ [flake.modules.nixos.common]
        ++ [flake.modules.nixos."hosts/${host}"]
        ++ [flake.modules.nixos."users/${user}"]
        ++ [
          {
            networking.hostName = host;
          }
        ];
    };
in {
  flake.nixosConfigurations = {
    acer = linux "acer" {
      extraMods = attrValues {
        inherit
          (inputs.nixos-hardware.nixosModules)
          common-pc-laptop
          common-pc-laptop-ssd
          common-cpu-intel
          ;
      };
    };
    minibookx = linux "minibookx" {
      extraMods = attrValues {
        inherit
          (inputs.nixos-hardware.nixosModules)
          chuwi-minibook-x
          ;
      };
    };
    sakura = linux "sakura" {
      extraMods = attrValues {
        inherit
          (inputs.nixos-hardware.nixosModules)
          common-cpu-amd
          common-cpu-amd-pstate
          common-gpu-amd
          common-pc-ssd
          ;
      };
    };
  };
}
