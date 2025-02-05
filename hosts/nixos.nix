{
  lib,
  pkgs,
  inputs,
  specialArgs,
  user,
}:
let
  mkNixosConfiguration = 
    host:
    lib.nixosSystem {
      inherit pkgs;
    specialArgs = specialArgs // {
      inherit host user;
      isNixos = true;
      isLaptop = host == "acer";
      home = /home/${user};
      dotfile = /home/${user}/prejects/Wolborg;
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
            isNixos = true;
            isLaptop = host == "acer";
            dotfile = /home/${user}/projects/Wolborg;
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
      inputs.disko.nixosModules.disko
      inputs.niri.nixosModules.niri
      inputs.stylix.nixosModules.stylix
      inputs.impermanence.nixosModules.impermanence
      inputs.agenix.nixosModules.default
    ];
  };
in
{
  acer = mkNixosConfiguration "acer" { };
  sakura = mkNixosConfiguration "sakura"{ };
}
