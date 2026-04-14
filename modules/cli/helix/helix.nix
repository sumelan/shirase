{
  lib,
  self,
  ...
}: let
  baseConfig = import ./_config.nix {};
  nordicTheme = import ./_themes.nix {};
  baseLangs = lib: pkgs: import ./_languages.nix {inherit lib pkgs;};
in {
  flake.wrappers.helix = {
    wlib,
    pkgs,
    ...
  }: {
    imports = [wlib.wrapperModules.helix];

    settings = baseConfig;
    themes = nordicTheme;
    languages = baseLangs lib pkgs;
  };

  flake.modules.nixos.default = {
    config,
    pkgs,
    dotfile,
    ...
  }: {
    nixpkgs.overlays = [
      (_: prev: {
        helix = self.wrappers.helix.wrap {
          pkgs = prev;
          languages =
            baseLangs lib prev
            // {
              language-server.nixd.config.nixd = let
                myFlake = ''(builtins.getFlake "${dotfile}")'';
              in {
                nixos.expr = "import ${myFlake}.inputs.nixpkgs { }";
                options = {
                  nixos.expr = "${myFlake}.nixosConfigurations.${config.networking.hostName}.options";
                  flake-parts.expr = "${myFlake}.debug.options";
                };
              };
            };
        };
      })
    ];

    hj = {
      packages = [
        pkgs.helix # overlay-ed above
      ];
    };

    custom = {
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

      fileSystem = {
        cache.home.directories = [
          # helix log
          ".cache/helix"
        ];
      };
    };
  };
}
