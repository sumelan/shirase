{
  config,
  lib,
  ...
}: {
  flake.custom.hjemConfigs.ghostty = {
    pkgs,
    user,
    ...
  }: let
    local = config.flake.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    hjem.users.${user}.rum = {
      programs.ghostty = {
        enable = lib.mkDefault true;
        package = local.ghostty;
        systemd.enable = true;
      };
    };

    environment.sessionVariables = {
      TERMINAL = "ghostty";
    };
  };
}
