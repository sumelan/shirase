{
  config,
  lib,
  ...
}: let
  inherit (config) flake;
in {
  flake.custom.hjemConfigs.nushell = {
    pkgs,
    user,
    ...
  }: let
    inherit (flake.packages.${pkgs.stdenv.hostPlatform.system}) nushell;
  in {
    hjem.users.${user}.rum = {
      programs.nushell = {
        enable = lib.mkDefault true;
        package = nushell;
      };
    };

    custom.fileSystem = {
      persist.home.directories = [
        ".config/nushell"
      ];
    };
  };
}
