{
  self,
  inputs,
  ...
}: let
  linux = mkNixos "x86_64-linux" "nixos";

  mkNixos = system: cls: hostname: {modules ? []}: let
    customLib = import ../lib/lib.nix {};
    functions = import ../functions/functions.nix {inherit pkgs;};

    pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    specialArgs = {
      inherit self inputs customLib functions;
    };

    inputModules = let
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
  in
    inputs.nixpkgs.lib.nixosSystem {
      inherit pkgs specialArgs;
      modules =
        inputModules
        ++ [
          (inputs.import-tree ../hosts/${hostname})
          (inputs.import-tree ../users/root)
          (inputs.import-tree ../users/sumelan)
          ../modules/nixos/base.nix
          {networking.hostName = hostname;}
        ]
        ++ modules;
    };
in {
  acer = linux "acer" {
    modules = [
      ../modules/nixos/laptop.nix
      ../modules/nixos/intel.nix
    ];
  };

  minibookx = linux "minibookx" {
    modules = [
      ../modules/nixos/laptop.nix
      ../modules/nixos/intel.nix
    ];
  };

  sakura = linux "sakura" {
    modules = [
      ../modules/nixos/amd.nix
      ../modules/nixos/server.nix
    ];
  };

  omen = linux "omen" {
    modules = [
      ../modules/nixos/desktop.nix
      ../modules/nixos/nvidia.nix
    ];
  };
}
