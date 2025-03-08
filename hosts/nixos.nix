{
  lib,
  inputs,
  specialArgs,
  user,
  ...
}@args:
let
  mkNixosConfiguration = 
    host:
    {
      pkgs ? args.pkgs,
    }:
    lib.nixosSystem {
      inherit pkgs;

    specialArgs = specialArgs // {
      inherit host user;
      isLaptop = host == "acer";
      isServer = host == "sakura";
      dotfiles = "/persist/home/${user}/projects/wolborg";
    };
    modules = [
      ./${host} # host specific configuration
      ./${host}/hardware.nix  # host specific hardware configuration
      ../system # system modules
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = false;
          useUserPackages = true;

          extraSpecialArgs = specialArgs // {
            inherit host user;
            isLaptop = host == "acer";
            isServer = host == "sakura";
            wallpapers = {
              "DP-1" = {
                path = ./sakura/wallpaper.png;
                convertMethod = "none"; # gonord, lutgen, none
              };
              "eDP-1" = {
                path = ./acer/wallpaper.png;
                convertMethod = "none"; # gonord, lutgen, none
              };
            };
            dotfiles = "/persist/home/${user}/projects/wolborg";
          };
          users.${user} = {
            nixpkgs.config.allowUnfree = true;
            imports = [
              ./${host}/home.nix  # host specific home-manager configuration
              ../home-manager # home-manager modules
              inputs.nix-index-database.hmModules.nix-index
              inputs.nvf.homeManagerModules.default
            ];
          };
        };
      }
      # alias for home-manager
      (lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" user ])
      inputs.stylix.nixosModules.stylix
      inputs.niri.nixosModules.niri
      inputs.impermanence.nixosModules.impermanence
      inputs.agenix.nixosModules.default
    ];
  };
in
{
  acer = mkNixosConfiguration "acer" { };
  sakura = mkNixosConfiguration "sakura"{ };
}
