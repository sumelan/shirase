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
      };
      modules = [
        ./${host} # host specific configuration
        ./${host}/hardware.nix # host specific hardware configuration
        ../system # system modules
        ../overlays # overlay
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = false;
            useUserPackages = true;

            extraSpecialArgs = specialArgs // {
              inherit host user;
              isLaptop = host == "acer";
              isServer = host == "sakura";
            };
            users.${user} = {
              nixpkgs.config.allowUnfree = true;
              imports = [
                ./${host}/home.nix # host specific home-manager configuration
                ../home-manager # home-manager modules
              ];
            };
          };
        }
        # alias for home-manager
        (lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" user ])
      ];
    };
in
{
  acer = mkNixosConfiguration "acer" { };
  sakura = mkNixosConfiguration "sakura" { };
}
