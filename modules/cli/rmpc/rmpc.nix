{
  lib,
  self,
  ...
}: let
  inherit (lib) mkDefault;
in {
  flake.wrappers.rmpc = {
    config,
    wlib,
    ...
  }: {
    imports = [wlib.modules.default];

    config.package = mkDefault config.pkgs.rmpc;
    # TODO: add `--config` flags after v0.12 released
    config.flags = {
      "--theme" = import ./_theme.nix {inherit config;};
    };
  };

  flake.modules.nixos.default = {
    config,
    pkgs,
    ...
  }: {
    nixpkgs.overlays = [
      (_: _prev: {
        inherit (pkgs.custom) rmpc;
      })
    ];

    hj = {
      packages = [
        pkgs.rmpc # overlay-ed above
      ];

      xdg.config.files."rmpc/config.ron".source = import ./_config.nix {inherit config pkgs;};
    };

    custom.fileSystem = {
      cache.home.directories = [
        ".cache/rmpc/youtube"
      ];
    };
  };
}
