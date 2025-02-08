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
      dotfiles = "/persist/home/${user}/projects/wolborg";
    };
    modules = [
      ./${host} # host specific configuration
      ./${host}/hardware.nix  # host specific hardware configuration
      ../system # system modules
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;

          extraSpecialArgs = specialArgs // {
            inherit host user;
            isLaptop = host == "acer";
            dotfiles = "/persist/home/${user}/projects/wolborg";
          };
          users.${user} = {
            imports = [
              ./${host}/home.nix  # host specific home-manager configuration
              ../home-manager # home-manager modules
              inputs.nixcord.homeManagerModules.nixcord
              inputs.nvf.homeManagerModules.default
            ];
          };
        };
      }
      # alias for home-manager
      (lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" user ])
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
