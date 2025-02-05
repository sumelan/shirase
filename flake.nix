{
  description = "Wolborg";

  inputs = {
    # nixpkgs links
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";

    # hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    
    # disk partitioning
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home-manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Niri
    niri.url = "github:sodiboo/niri-flake";

    # impermanence
    impermanence.url = "github:nix-community/impermanence";

    # theming
    stylix.url = "github:danth/stylix";

    # Secrets
    agenix.url = "github:yaxitech/ragenix";

    # Neovim
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # discord
    nixcord.url = "github:kaylorben/nixcord";
  };
  outputs = 
    inputs@{ nixpkgs, self, home-manager, ... }:
    let
      system = "x86_64-linux";
      user = "sumelan";

      mkSystem = system: {
        inherit system;
        specialArgs = {
          inherit self inputs user;
        };
      };
    in
    {
      nixosConfigurations = import ./hosts/nixos.nix (mkSystem system);
    };
  }
