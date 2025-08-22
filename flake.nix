{
  description = "Shirase: sumelan's nixos configuration";

  inputs = {
    # use unstable brunch
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix.url = "github:ryantm/agenix";

    dm-shell.url = "github:AvengeMedia/DankMaterialShell";

    dimland.url = "github:keifufu/dimland";

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    niri.url = "github:sodiboo/niri-flake";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
    };

    noctalia-shell.url = "github:sumelan/noctalia-shell";

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    # Get the extended lib from ./lib/custom.nix
    lib = import ./lib/custom.nix {
      inherit
        system
        pkgs
        inputs
        self
        ;
      inherit (nixpkgs) lib;
      inherit (inputs) home-manager;
    };

    forAllSystems = lib.genAttrs [
      "x86_64-linux"
      "aarch64-linux"
    ];
    forAllPkgs = fn: forAllSystems (system: fn {inherit system pkgs inputs;});
  in {
    inherit lib;
    # NixOS configuration entrypoint
    nixosConfigurations = import ./hosts {inherit lib;};
    # Your custom packages, accessible through 'nix build', 'nix shell', etc
    packages = forAllPkgs (import ./packages);
  };
}
