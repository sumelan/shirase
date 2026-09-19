{
  inputs,
  config,
  ...
}: let
  inherit (inputs) nixpkgs;

  linux = mkNixos "x86_64-linux" "nixos";

  mkNixos = system: cls: host: {
    user ? "sumelan",
    dotfile ? "/persist/home/${user}/Projects/shirase",
    extraModules ? [],
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
      flakeLib = config.flake.custom.lib;
      # These require pkgs to be passed so collect and do once to get the ready functions
      functions = builtins.mapAttrs (_: v: v {inherit pkgs;}) config.flake.custom.functions;
    };
  in
    nixpkgs.lib.nixosSystem {
      inherit pkgs specialArgs;
      modules =
        defaultModules
        ++ extraModules
        ++ builtins.attrValues {
          inherit
            (config.flake.modules.nixos)
            core
            default
            hjem
            ;
          hostModules = config.flake.modules.nixos."hosts/${host}";
          userModules = config.flake.modules.nixos."users/${user}";
        }
        ++ [{networking.hostName = host;}];
    };

  defaultModules = let
    mkModules = {
      name,
      modules ? "nixosModules",
      opt ? "default",
    }:
      inputs.${name}.${modules}.${opt};
  in [
    (mkModules {name = "hjem";})
    (mkModules {name = "nixos-plymouth";})
    (mkModules {name = "nix-secrets";})
    (mkModules {name = "preservation";})
    (mkModules {name = "inshellah";})

    (mkModules {
      name = "nix-index-database";
      opt = "nix-index";
    })
    (mkModules {
      name = "mangowm";
      opt = "mango";
    })
  ];
in {
  flake.nixosConfigurations = {
    acer = linux "acer" {
      extraModules = builtins.attrValues {
        inherit
          (config.flake.modules.nixos)
          acer-al14
          laptop
          intel
          ;
      };
    };
    minibookx = linux "minibookx" {
      extraModules = builtins.attrValues {
        inherit
          (config.flake.modules.nixos)
          chuwi-minibook-x
          laptop
          intel
          ;
      };
    };
    sakura = linux "sakura" {
      extraModules = builtins.attrValues {
        inherit
          (config.flake.modules.nixos)
          minisforum-um773se
          amd
          ;
      };
    };
    omen = linux "omen" {
      extraModules = builtins.attrValues {
        inherit
          (config.flake.modules.nixos)
          nvidia
          ;
      };
    };
  };
}
