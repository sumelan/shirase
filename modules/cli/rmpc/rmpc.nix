_: {
  flake.modules.nixos.default = {
    config,
    pkgs,
    ...
  }: {
    hj = {
      packages = [
        pkgs.rmpc
      ];

      xdg.config.files = {
        "rmpc/config.ron".source = import ./_config.nix {inherit config pkgs;};
        "rmpc/themes/custom.ron".source = import ./_theme.nix {inherit pkgs;};
      };
    };

    custom.fileSystem = {
      cache.home.directories = [
        ".cache/rmpc/youtube"
      ];
    };
  };
}
