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

      xdg.mime-apps = {
        default-applications = {
          "x-scheme-handler/terminal" = "footclient.desktop";
        };
      };
    };

    environment.sessionVariables = {
      TERMINAL = "foot";
    };
  };
}
