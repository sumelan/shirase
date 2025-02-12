{
  description = "Wolborg";

  inputs = {
    # nixpkgs links
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";

    # hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    
    # home-manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # windows manager
    niri.url = "github:sodiboo/niri-flake";

    # impermanence
    impermanence.url = "github:nix-community/impermanence";

    # theming
    stylix.url = "github:danth/stylix";

    # database
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secrets
    agenix.url = "github:ryantm/agenix";

    # Neovim
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # spotify
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # webapp
    nix-webapps.url = "github:TLATER/nix-webapps";
  };
  outputs = 
    inputs@{ nixpkgs, self, ... }:
    let
      system = "x86_64-linux";
      user = "sumelan";

      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      lib = import ./lib.nix {
        inherit (nixpkgs) lib;
        inherit pkgs;
        inherit (inputs) home-manager;
      };

      mkSystem = system: {
        inherit
          self
          inputs
          nixpkgs
          lib
          pkgs
          user
          system
          ;
        specialArgs = {
          inherit self inputs;
        };
      };
      commonSysytem = mkSystem system;
      # call with forAllSystems (commonArgs: function body)
      forAllSystems =
        fn:
        lib.genAttrs [
          "x86_64-linux"
          "aarch64-linux"
          "x86_64-darwin"
          "aarch64-darwin"
        ] (system: fn (mkSystem system));
    in
    {
      nixosConfigurations = (import ./hosts/nixos.nix commonSysytem);

      inherit lib self;

      packages = forAllSystems (commonSystem': (import ./packages commonSystem'));
    };
  }
