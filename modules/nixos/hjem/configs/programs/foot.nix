{
  config,
  lib,
  ...
}: let
  inherit (config) flake;
in {
  flake.custom.hjemConfigs.foot = {
    pkgs,
    user,
    ...
  }: let
    inherit (flake.packages.${pkgs.stdenv.hostPlatform.system}) foot;
  in {
    hjem.users.${user}.rum = {
      programs.foot = {
        enable = lib.mkDefault false;
        package = foot;
        server.enable = lib.mkDefault false;
      };
    };
  };
}
