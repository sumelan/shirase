{
  config,
  inputs,
  ...
}: let
  flake.nixosConfigurations = {
    acer = linux "acer" {};
    minibookx = linux "minibookx" {};
    sakura = linux "sakura" {};
  };

  linux = mkNixos "x86_64-linux" "nixos";

  mkNixos = system: cls: host: {user ? "sumelan"}: let
    pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    hostModule = config.flake.modules.nixos."hosts_${host}";
    userModule = config.flake.modules.nixos."user_${user}";
    specialArgs = {
      inherit inputs host user;
    };
  in
    inputs.nixpkgs.lib.nixosSystem {
      inherit system pkgs specialArgs;
      modules =
        hostModule.imports
        ++ userModule.imports
        ++ [../../overlays]
        ++ [
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = specialArgs;
            };
          }
          # alias for home-manager
          (inputs.nixpkgs.lib.mkAliasOptionModule ["hm"] ["home-manager" "users" user])
        ];
    };
in {
  inherit flake;
}
