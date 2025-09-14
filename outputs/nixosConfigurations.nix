{
  inputs,
  lib,
  ...
}: let
  inherit (inputs) self nixpkgs;

  customLib = import ../flake/lib {inherit (nixpkgs) lib;};

  defaultMods = [
    inputs.agenix.nixosModules.default
    inputs.niri.nixosModules.niri
    inputs.stylix.nixosModules.stylix
    inputs.impermanence.nixosModules.impermanence
    ../flake/nixos
  ];

  mkSystem = {
    host,
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
        isServer = hardware == "server";
      };

      modules =
        modules
        ++ defaultMods
        ++ [
          ../flake/hosts/${host}
          ../flake/hosts/${host}/hardware.nix
        ]
        ++ [../flake/users/${user}.nix]
        ++ [../flake/overlays] # nixpkgs.overlay
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
                isServer = hardware == "server";
              };

              users.${user} = {
                imports = [
                  ../flake/hosts/${host}/home.nix
                  ../flake/home-manager
                ];
              };
            };
          }
          (lib.mkAliasOptionModule ["hm"] ["home-manager" "users" user]) # alias for home-manager
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
    acer = mkSystem {
      host = "acer";
      user = "sumelan";
      hardware = "laptop";
    };
    sakura = mkSystem {
      host = "sakura";
      user = "sumelan";
      hardware = "server";
    };
  };
}
