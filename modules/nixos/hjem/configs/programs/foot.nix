{config, ...}: let
  inherit (config) flake;
in {
  flake.custom.hjemConfigs.foot = {pkgs, ...}: let
    inherit (flake.packages.${pkgs.stdenv.hostPlatform.system}) foot;
  in {
    hj.rum = {
      programs.foot = {
        enable = true;
        package = foot;
        # add `foot --server` in wm's startup
        server.enable = false;
      };
    };
  };
}
