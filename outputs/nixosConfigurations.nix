{
  lib,
  inputs,
  ...
}: let
  inherit
    (lib)
    mkAliasOptionModule
    ;
  inherit (inputs) self nixpkgs;

  customLib = import ../flake/lib {inherit (nixpkgs) lib;};

  defaultMods = [
    inputs.agenix.nixosModules.default
    inputs.impermanence.nixosModules.impermanence
    inputs.niri.nixosModules.niri
    inputs.noctalia-shell.nixosModules.default
    inputs.stylix.nixosModules.stylix
    ../flake/nixos
  ];

  mkSystem = host: {
    user,
    system ? "x86_64-linux",
    hardware,
    modules ? [],
  }:
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit system inputs self host user;
        flakePath = "/persist/home/${user}/projects/shirase";
        isLaptop = hardware == "laptop";
        isDesktop = hardware == "desktop";
      };

      modules =
        modules
        ++ defaultMods
        ++ [
          ../flake/hosts/${host}
          ../flake/hosts/${host}/hardware.nix
        ]
        ++ [../flake/users/${user}.nix]
        ++ [../flake/overlays] # nixpkgs.overlays
        ++ [
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit inputs self host user;
                flakePath = "/persist/home/${user}/projects/shirase";
                isLaptop = hardware == "laptop";
                isDesktop = hardware == "desktop";
              };

              users.${user} = {
                imports = [
                  ../flake/hosts/${host}/home.nix
                  ../flake/home-manager
                ];
              };
            };
          }
          (mkAliasOptionModule ["hm"] ["home-manager" "users" user]) # alias for home-manager
        ];

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          (
            _: prev: {lib = prev.lib // customLib;}
          )
        ];
      };
    };
in {
  flake.nixosConfigurations = {
    acer = mkSystem "acer" {
      user = "sumelan";
      hardware = "laptop";
    };
    sakura = mkSystem "sakura" {
      user = "sumelan";
      hardware = "desktop";
    };
  };
}
