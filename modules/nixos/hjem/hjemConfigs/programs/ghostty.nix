{
  config,
  lib,
  ...
}: let
  inherit (config) flake;
in {
  flake.custom.hjemConfigs.ghostty = {
    pkgs,
    user,
    ...
  }: let
    inherit (flake.packages.${pkgs.stdenv.hostPlatform.system}) ghostty;
  in {
    hjem.users.${user}.rum = {
      programs.ghostty = {
        enable = lib.mkDefault true;
        package = ghostty;
        systemd.enable = true;
      };
    };
  };
}
