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

  defaultNixMods = [
    inputs.impermanence.nixosModules.impermanence
    inputs.niri.nixosModules.niri
    inputs.stylix.nixosModules.stylix
    ../flake/nixos
  ];

  defaultHomeMods = [
    inputs.nix-index-database.homeModules.nix-index
    inputs.noctalia-shell.homeModules.default
    ../flake/home-manager
  ];

  mkSystem = host: {
    user,
    system ? "x86_64-linux",
    hardware,
    nixModules ? [],
    homeModules ? [],
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
        nixModules
        ++ defaultNixMods
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
                imports =
                  homeModules
                  ++ defaultHomeMods
                  ++ [../flake/hosts/${host}/home.nix];
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
      homeModules = [
        inputs.spicetify-nix.homeManagerModules.default
      ];
    };
    sakura = mkSystem "sakura" {
      user = "sumelan";
      hardware = "desktop";
      nixModules = [
        inputs.agenix.nixosModules.default
      ];
    };
  };
}
