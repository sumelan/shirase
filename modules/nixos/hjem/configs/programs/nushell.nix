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
        package = lib.mkDefault nushell;
      };
    };

    custom.fileSystem = {
      cache.home.directories = [
        ".config/nushell"
      ];
    };
  };
}
