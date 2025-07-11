{
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
      system ? "x86_64-linux",
    }:
    let
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      specialArgs = {
        inherit
          self
          inputs
          host
          user
          ;
        flakePath = "/persist/home/${user}/projects/shirase";
        isLaptop = hardware == "laptop";
        isDesktop = hardware == "desktop";
      };
    in
    lib.nixosSystem {
      inherit pkgs system specialArgs;
      modules =
        [
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
