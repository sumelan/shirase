{
  inputs,
  config,
  ...
}: let
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
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
    specialArgs = {
      inherit user dotfile;
      # This intentionally does not collide with `lib`
      flakeLib = flake.custom.lib;
      # These require pkgs to be passed so collect and do once to get the ready functions
      functions = builtins.mapAttrs (_: v: v {inherit pkgs;}) flake.custom.functions;
    };
  in
    nixpkgs.lib.nixosSystem {
      inherit pkgs specialArgs;
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
    acer = linux "acer" {};
    minibookx = linux "minibookx" {};
    sakura = linux "sakura" {};
  };
}
