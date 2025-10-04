# passing system etc. to nixosSystem is a useless deprecated pattern
# that is superseded by nixpkgs.hostPlatform etc. in hardware-configuration.nix
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
    inputs.spicetify-nix.homeManagerModules.default
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
      specialArgs = {
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
  };

  # minibook = mkSystem "minibook" {
  #   user = "sumelan";
  #   hardware = "laptop";
  #   nixosModules = [
  #     inputs.nix-chuwi-minibook-x.nixosModules.default
  #   ];
  # };

  sakura = mkSystem "sakura" {
    user = "sumelan";
    hardware = "desktop";
    nixModules = [
      inputs.agenix.nixosModules.default
    ];
  };
}
