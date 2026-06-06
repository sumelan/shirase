{
  config,
  lib,
  ...
}: let
  inherit (config) flake;
in {
  flake.custom.hjemConfigs.foot = {pkgs, ...}: let
    inherit (flake.packages.${pkgs.stdenv.hostPlatform.system}) foot;
  in {
    hj.rum = {
      programs.foot = {
        enable = lib.mkDefault false;
        package = foot;
        server.enable = lib.mkDefault false;
      };
    };
  };
}
