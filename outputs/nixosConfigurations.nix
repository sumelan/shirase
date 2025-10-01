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
      # Special args are a better mechanism than overlays
      # because it is significantly more obvious what came from where without indirection
      specialArgs = {
        # passing system etc. to nixosSystem is a useless deprecated pattern
        # that is superseded by nixpkgs.hostPlatform etc. in hardware-configuration.nix
        inherit self inputs customLib host user;
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
                inherit self inputs customLib host user;
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
      homeModules = [
        inputs.spicetify-nix.homeManagerModules.default
      ];
    };
  };
}
