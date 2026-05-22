{
  inputs,
  config,
  ...
}: let
  inherit (inputs) nixpkgs;
  inherit (config) flake;

  defaultMods = let
    mods = {
      name,
      modules ? "nixosModules",
      output ? "default",
    }:
      inputs.${name}.${modules}.${output};
  in [
    (mods {name = "hjem";})
    (mods {name = "niri-nix";})
    (mods {name = "run0-sudo-shim";})
    (mods {name = "impermanence";})
    (mods {
      name = "dankMaterialShell";
      output = "dank-material-shell";
    })
    (mods {
      name = "dankMaterialShell";
      output = "greeter";
    })
    (mods {
      name = "nix-hazkey";
      output = "hazkey";
    })
    (mods {
      name = "nix-index-database";
      output = "nix-index";
    })
    (mods {
      name = "sops-nix";
      output = "sops";
    })
  ];

  linux = mkNixos "x86_64-linux" "nixos";

  mkNixos = system: cls: host: {
    user ? "sumelan",
    dotfile ? "/persist/home/${user}/Projects/shirase",
    extraMods ? [],
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
        defaultMods
        ++ extraMods
        ++ [flake.modules.nixos.core]
        ++ [flake.modules.nixos."hosts/${host}"]
        ++ [flake.modules.nixos."users/${user}"]
        ++ [
          # alias for hjem
          (inputs.nixpkgs.lib.mkAliasOptionModule ["hj"] ["hjem" "users" user])
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
