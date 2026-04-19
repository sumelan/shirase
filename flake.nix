{
  description = "Shirase: sumelan's nixos configuration";

  outputs = {
    flake-parts,
    wrappers,
    import-tree,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      debug = true;
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin"];
      imports = [
        flake-parts.flakeModules.modules
        wrappers.flakeModules.wrappers
        (import-tree ./packages)
        (import-tree ./modules)
      ];
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # no nixpkgs inputs
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    # hjem
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # niri
    niri-unstable = {
      url = "github:niri-wm/niri";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri-nix = {
      url = "git+https://codeberg.org/BANanaD3V/niri-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        niri-unstable.follows = "niri-unstable";
      };
    };

    # dms-related
    dankMaterialShell = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "";
      };
    };

    danksearch = {
      url = "github:AvengeMedia/danksearch";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # misc
    impermanence = {
      url = "github:nix-community/impermanence";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "";
      };
    };

    nix-hazkey = {
      url = "github:aster-void/nix-hazkey";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "";
      };
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "";
        flake-parts.follows = "flake-parts";
      };
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wrappers = {
      url = "github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
