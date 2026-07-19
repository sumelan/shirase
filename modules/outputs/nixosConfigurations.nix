{
  inputs,
  config,
  ...
}: let
  inherit (inputs) nixpkgs;
  inherit (config) flake;

  defaultModules = let
    mkModules = {
      name,
      modules ? "nixosModules",
      opt ? "default",
    }:
      inputs.${name}.${modules}.${opt};
  in [
    (mkModules {name = "hjem";})
    (mkModules {name = "niri-nix";})
    (mkModules {name = "nixos-plymouth";})
    (mkModules {name = "impermanence";})
    (mkModules {name = "noctalia-greeter";})
    (mkModules {
      name = "nix-hazkey";
      opt = "hazkey";
    })
    (mkModules {
      name = "nix-index-database";
      opt = "nix-index";
    })
    (mkModules {
      name = "sops-nix";
      opt = "sops";
    })
  ];

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
      flakeLib = flake.custom.lib;
      # These require pkgs to be passed so collect and do once to get the ready functions
      functions = builtins.mapAttrs (_: v: v {inherit pkgs;}) flake.custom.functions;
    };
  in
    nixpkgs.lib.nixosSystem {
      inherit pkgs specialArgs;
      modules =
        defaultModules
        ++ extraModules
        ++ [flake.modules.nixos.core]
        ++ [flake.modules.nixos."hosts/${host}"]
        ++ [flake.modules.nixos."users/${user}"]
        ++ [
          {
            networking.hostName = host;
          }
        ];
    };
in {
  flake.nixosConfigurations = {
    acer = linux "acer" {};
    minibookx = linux "minibookx" {};
    sakura = linux "sakura" {};
  };
}
