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
      packages ? "stable", # nixpkgs branch to use, stable or unstable
      system ? "x86_64-linux",
    }:
    let
      selectedNixpkgs = if packages == "stable" then inputs.nixpkgs-stable else inputs.nixpkgs-unstable;
      selectedHomeManager =
        if packages == "stable" then inputs.home-manager-stable else inputs.home-manager-unstable;

      systemPkgs = import selectedNixpkgs {
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
        isLaptop = hardware == "laptop";
        isDesktop = hardware == "desktop";
      };
    in
    lib.nixosSystem {
      inherit system specialArgs;
      pkgs = systemPkgs;
      modules =
        # host's system and hardware config
        [
          ../hosts/${host}
          ../hosts/${host}/hardware.nix
        ]
        ++ [ ../users/${user}.nix ] # user config
        ++ [ ../system ] # system-modules
        ++ [ ../overlays ] # nixpkgs.overlay
        ++ [
          selectedHomeManager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = specialArgs;
              users.${user} = {
                imports = [ ../hosts/${host}/home.nix ] ++ [ ../home-manager ]; # host's home-manager modules
              };
            };
          }
          (lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" user ]) # alias for home-manager
        ];
    };
}
