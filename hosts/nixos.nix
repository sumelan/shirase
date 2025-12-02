{inputs, ...}: let
  inherit (inputs) nixpkgs;

  # Get the extended lib from ./lib
  # https://www.notashelf.dev/posts/extended-nixpkgs-lib
  lib = import ../modules/lib {inherit inputs;};

  inherit (lib) mkAliasOptionModule;

  defaultNixMods = [
    inputs.impermanence.nixosModules.impermanence
    inputs.niri.nixosModules.niri
    inputs.sops-nix.nixosModules.sops
    ../modules/nixos
  ];

  defaultHomeMods = [
    inputs.nix-index-database.homeModules.nix-index
    inputs.noctalia.homeModules.default
    ../modules/home-manager
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

      # passing system etc. to nixosSystem is a useless deprecated pattern
      # that is superseded by `nixpkgs.hostPlatform` etc. in `hardware-configuration.nix`
      specialArgs = {
        inherit inputs lib host user;
        flakePath = "/persist/home/${user}/Projects/shirase";
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
        ++ [../modules/overlays] # nixpkgs.overlays
        ++ [
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit inputs lib host user;
                flakePath = "/persist/home/${user}/Projects/shirase";
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
      # using `with` is considered an anti-pattern by nix.dev
      # https://nix.dev/guides/best-practices#best-practices
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
    packages = import ../modules/packages {
      inherit inputs pkgs;
    };
  };
}
