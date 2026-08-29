{
  config,
  lib,
  ...
}: {
  flake.custom.hjemConfigs.foot = {
    pkgs,
    user,
    ...
  }: let
    local = config.flake.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    hjem.users.${user} = {
      rum = {
        programs.foot = {
          enable = lib.mkDefault true;
          package = local.foot;
          server.enable = true;
        };
      };
    };

    environment.sessionVariables = {
      TERMINAL = "foot";
    };
  };
}
