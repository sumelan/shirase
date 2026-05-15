{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.nixos.rmpc = {
    config,
    pkgs,
    ...
  }: let
    inherit (flake.packages.${pkgs.stdenv.hostPlatform.system}) rmpc;
  in {
    hj = {
      packages = [rmpc];

      xdg.config.files."rmpc/config.ron".source = import ./_config.nix {
        inherit pkgs;
        cache = config.hj.xdg.cache.directory;
      };
    };

    custom.fileSystem = {
      cache.home.directories = [
        ".cache/rmpc/youtube"
      ];
    };
  };
}
