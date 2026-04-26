{
  lib,
  self,
  ...
}: let
  baseConfig = import ./_config.nix {};
  baseLangs = pkgs: import ./_languages.nix {inherit lib pkgs;};
  baseThemes = import ./_themes.nix {};
in {
  flake.wrappers.helix = {
    config,
    wlib,
    ...
  }: {
    imports = [wlib.wrapperModules.helix];

    settings = baseConfig;
    languages = baseLangs (config.pkgs);
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
          # add extra settings
          settings = {
            # custom-theme
            theme = "catppuccinFrappe";
            # use yazi as file tree picker
            # https://yazi-rs.github.io/docs/tips/#helix
            keys.normal = {
              "C-y" = [
                '':sh rm -f /tmp/unique-ca1ea106''
                '':insert-output yazi "%{buffer_name}" --chooser-file=/tmp/unique-ca1ea106''
                '':sh printf "\x1b[?1049h\x1b[?2004h" > /dev/tty''
                '':open %sh{cat /tmp/unique-ca1ea106}''
                '':redraw''
                '':set mouse false''
                '':set mouse true''
              ];
            };
          };
          # add extra settings
          languages = {
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
          themes = baseThemes;
        };
      })
    ];
    environment.systemPackages = [
      pkgs.helix # overlay-ed above
    ];

    hj = {
      packages = [
        pkgs.helix # overlay-ed above
      ];

      xdg.mime-apps = {
        default-applications = {
          "text/plain" = "helix.desktop";
          "application/x-shellscript" = "helix.desktop";
          "application/xml" = "helix.desktop";
        };
        added-associations = {
          "text/csv" = "helix.desktop";
        };
      };
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
