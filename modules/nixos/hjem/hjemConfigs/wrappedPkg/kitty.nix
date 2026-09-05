{config, ...}: {
  flake.custom.hjemConfigs.kitty = {
    pkgs,
    user,
    ...
  }: let
    local = config.flake.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    hjem.users.${user} = {
      packages = [local.kitty];
    };

    environment.sessionVariables = {
      TERMINAL = "kitty";
    };
  };
}
