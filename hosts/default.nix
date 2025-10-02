{
  lib,
  pkgs,
  inputs,
  self,
  nixpkgs,
  ...
}: let
  defaultNixMods = [
    inputs.impermanence.nixosModules.impermanence
    inputs.niri.nixosModules.niri
    inputs.stylix.nixosModules.stylix
    ../nixos
  ];

  defaultHomeMods = [
    inputs.nix-index-database.homeModules.nix-index
    inputs.noctalia-shell.homeModules.default
    ../home-manager
  ];

  mkSystem = host: {
    user,
    hardware,
    nixModules ? [],
    homeModules ? [],
  }:
    nixpkgs.lib.nixosSystem {
      inherit pkgs;
      # Special args are a better mechanism than overlays
      # because it is significantly more obvious what came from where without indirection
      specialArgs = {
        # passing system etc. to nixosSystem is a useless deprecated pattern
        # that is superseded by nixpkgs.hostPlatform etc. in hardware-configuration.nix
        inherit inputs self lib host user;
        flakePath = "/persist/home/${user}/projects/shirase";
        isLaptop = hardware == "laptop";
        isDesktop = hardware == "desktop";
      };

      modules =
        nixModules
        ++ defaultNixMods
        ++ [
          ./${host}
          ./${host}/hardware.nix
        ]
        ++ [../users/${user}.nix]
        ++ [../overlays] # nixpkgs.overlays
        ++ [
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit inputs self lib host user;
                flakePath = "/persist/home/${user}/projects/shirase";
                isLaptop = hardware == "laptop";
                isDesktop = hardware == "desktop";
              };

              users.${user} = {
                imports =
                  homeModules
                  ++ defaultHomeMods
                  ++ [./${host}/home.nix];
              };
            };
          }
          (lib.mkAliasOptionModule ["hm"] ["home-manager" "users" user]) # alias for home-manager
        ];
    };
in {
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
    homeModules = [
      inputs.spicetify-nix.homeManagerModules.default
    ];
  };
}
