{config, ...}: {
  flake.custom.hjemConfigs.nushell = {
    pkgs,
    user,
    ...
  }: let
    local = config.flake.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    hjem.users.${user} = {
      packages = [local.nushell];
    };

    custom.fileSystem = {
      persist.home.directories = [
        ".config/nushell"
      ];
    };
  };
}
