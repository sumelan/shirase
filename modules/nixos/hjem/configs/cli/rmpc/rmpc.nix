{config, ...}: let
  inherit (config) flake;
in {
  flake.custom.hjemConfigs.rmpc = {
    config,
    pkgs,
    user,
    ...
  }: let
    inherit (flake.packages.${pkgs.stdenv.hostPlatform.system}) rmpc;
  in {
    hjem.users.${user} = {
      packages = [rmpc];

      xdg.config.files."rmpc/config.ron".source = import ./_config.nix {
        inherit pkgs;
        cache = config.hjem.users.${user}.xdg.cache.directory;
      };
    };

    custom.fileSystem = {
      cache.home.directories = [
        ".cache/rmpc/youtube"
      ];
    };
  };
}
