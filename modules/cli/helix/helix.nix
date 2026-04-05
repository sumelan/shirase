{lib, ...}: {
  flake.wrappers.helix = {
    wlib,
    pkgs,
    ...
  }: {
    imports = [wlib.wrapperModules.helix];

    settings = import ./_config.nix {};
    languages = import ./_languages.nix {inherit lib pkgs;};
    themes = import ./_themes.nix {};
  };

  flake.modules.nixos.helix = {pkgs, ...}: {
    nixpkgs.overlays = [
      (_: _prev: {
        inherit (pkgs.custom) helix;
      })
    ];

    hj = {
      packages = [
        pkgs.helix # overlay-ed above
      ];
    };

    custom = {
      fileSystem = {
        cache.home.directories = [
          # helix log
          ".cache/helix"
        ];
      };

      programs.print-config = let
        target = pkgs.helix.configuration.passthru.generatedConfig;
      in {
        helix =
          # sh
          ''moor --lang toml "${target}/config.toml"'';

        helix-languages =
          # sh
          ''moor --lang toml "${target}/languages.toml"'';
      };
    };
  };
}
