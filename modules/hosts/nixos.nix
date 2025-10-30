# passing system etc. to nixosSystem is a useless deprecated pattern
# that is superseded by nixpkgs.hostPlatform etc. in hardware-configuration.nix
{inputs, ...}: let
  inherit (inputs) nixpkgs;

  # Get the extended lib from ./lib
  # https://www.notashelf.dev/posts/extended-nixpkgs-lib
  lib = import ../lib {inherit inputs;};

  inherit (lib) mkAliasOptionModule;

  defaultNixMods = [
    inputs.impermanence.nixosModules.impermanence
    inputs.niri.nixosModules.niri
    ../nixos
  ];

  defaultHomeMods = [
    inputs.astal-shell.homeManagerModules.default
    inputs.dimland.homeManagerModules.dimland
    inputs.nix-index-database.homeModules.nix-index
    inputs.spicetify-nix.homeManagerModules.default
    inputs.zen-browser.homeModules.twilight
    ../home-manager
  ];

  mkSystem = host: {
    system ? "x86_64-linux",
    user,
    hardware,
    nixModules ? [],
    homeModules ? [],
  }:
    nixpkgs.lib.nixosSystem {
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      specialArgs = {
        inherit inputs lib host user;
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
                inherit inputs lib host user;
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
          # alias for home-manager
          (mkAliasOptionModule ["hm"] ["home-manager" "users" user])
        ];
    };
in {
  flake.nixosConfigurations = {
    acer = mkSystem "acer" {
      user = "sumelan";
      hardware = "laptop";
      nixModules = builtins.attrValues {
        inherit
          (inputs.nixos-hardware.nixosModules)
          common-pc-laptop
          common-pc-laptop-ssd
          common-cpu-intel
          ;
      };
    };

    minibook = mkSystem "minibook" {
      user = "sumelan";
      hardware = "laptop";
      nixModules = [
        inputs.nix-chuwi-minibook-x.nixosModules.default
      ];
    };

    sakura = mkSystem "sakura" {
      user = "sumelan";
      hardware = "desktop";
      nixModules = builtins.attrValues {
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

  perSystem = {pkgs, ...}: {
    packages = import ../packages {
      inherit inputs pkgs;
    };
  };
}
