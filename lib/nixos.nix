{
  system,
  pkgs,
  self,
  inputs,
  lib,
}:
{
  mkSystem =
    host:
    {
      user ? throw ''Please specify user value, like user = "foo"'',
      hardware ? throw ''Please specify hardware value, like hardware = "laptop"'',
    }:
    let
      specialArgs = {
        inherit
          self
          inputs
          host
          user
          ;
        flakePath = "/persist/home/${user}/projects/shirase";
        isLaptop = hardware == "laptop";
        isServer = hardware == "server";
      };
    in
    lib.nixosSystem {
      inherit system pkgs specialArgs;
      modules = [
        ../hosts/${host}
        ../hosts/${host}/hardware.nix
      ]
      ++ [
        ../users/${user}.nix
        ../system
      ]
      ++ [ ../overlays ] # nixpkgs.overlay
      ++ [
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = specialArgs;
            users.${user} = {
              imports = [
                ../hosts/${host}/home.nix
                ../home-manager
              ];
            };
          };
        }
        (lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" user ]) # alias for home-manager
      ];
    };
}
