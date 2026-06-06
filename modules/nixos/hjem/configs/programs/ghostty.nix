{
  config,
  lib,
  ...
}: let
  inherit (config) flake;
in {
  flake.custom.hjemConfigs.ghostty = {pkgs, ...}: let
    inherit (flake.packages.${pkgs.stdenv.hostPlatform.system}) ghostty;
  in {
    hj.rum = {
      programs.ghostty = {
        enable = lib.mkDefault true;
        package = ghostty;
        systemd.enable = lib.mkDefault true;
      };
    };
  };
}
