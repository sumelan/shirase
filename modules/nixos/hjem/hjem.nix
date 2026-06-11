{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.nixos.default = {
    pkgs,
    user,
    ...
  }: {
    imports = [
      flake.modules.nixos.hjem-root
      flake.modules.nixos.hjem-common
    ];

    hjem = {
      clobberByDefault = true;
      linker = pkgs.smfh;
      # Pull in all my modules
      extraModules = builtins.attrValues flake.custom.hjemModules;

      users.${user} = {
        inherit user;
        directory = "/home/${user}";
      };
    };
  };
}
