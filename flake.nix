{
  description = "Shirase";

  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    impermanence.url = "github:nix-community/impermanence";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix.url = "github:ryantm/agenix";

    niri.url = "github:sodiboo/niri-flake";

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    way-edges = {
      url = "github:way-edges/way-edges";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-stable,
      nixpkgs-unstable,
      ...
    }:
    let
      inherit (self) outputs;
      inherit (nixpkgs) lib;

      # Create package sets for each system
      # systems = [ "aarch64-linux" "x86_64-linux" ];
      # forAllSystems = f: lib.genAttrs systems (system: f system);
      # forEachSystem = f: lib.genAttrs systems (sys: f pkgsFor.${sys});
    in
    {
      inherit lib;

      # packages = forEachSystem (pkgs: import ./packages { inherit pkgs; });

      mkSystem =
        host:
        {
          user ? throw ''Please specify user value, like user = "foo"'',
          hardware ? throw ''Please specify hardware value, like hardware = "laptop"'',
          packages ? "stable", # nixpkgs branch to use, stable or unstable
          system ? "x86_64-linux",
        }:
        let
          selectedNixpkgs = if packages == "stable" then nixpkgs-stable else nixpkgs-unstable;

          selectedHomeManager =
            if packages == "stable" then inputs.home-manager-stable else inputs.home-manager-unstable;

          systemPkgs = import selectedNixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
              allowBroken = false;
              allowUnsupportedSystem = false;
            };
          };
        in
        lib.nixosSystem {
          inherit (systemPkgs) system;
          pkgs = systemPkgs;

          specialArgs = {
            inherit
              self
              inputs
              outputs
              host
              user
              ;
            isLaptop = hardware == "laptop";
            isDesktop = hardware == "desktop";
          };

          modules = [
            ./hosts/${host} # host's system setting
            ./hosts/${host}/hardware.nix # hardware-config
            ./system # system module
            ./overlays
            selectedHomeManager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit
                    self
                    inputs
                    outputs
                    host
                    user
                    ;
                  isLaptop = hardware == "laptop";
                  isDesktop = hardware == "desktop";
                };
                users.${user} = {
                  imports = [
                    ./hosts/${host}/home.nix # host's user setting
                    ./home-manager # home-manager module
                  ];
                };
              };
            }
            (lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" user ]) # alias for home-manager
          ];
        };

      # device profile
      nixosConfigurations = {
        acer = self.mkSystem "acer" {
          user = "sumelan";
          hardware = "laptop";
          packages = "unstable";
        };
        sakura = self.mkSystem "sakura" {
          user = "sumelan";
          hardware = "desktop";
          packages = "unstable";
        };
      };
    };
}
