{
  inputs,
  lib,
  ...
}: let
  inherit (lib) mkOption mkForce recursiveUpdate;
  inherit (lib.types) submodule attrs;

  baseConfig = import ./_config.nix {};
  baseLangs = pkgs: import ./_languages.nix {inherit lib pkgs;};
  baseThemes = import ./_themes.nix {};
in {
  perSystem = {pkgs, ...}: {
    packages.helix = inputs.wrappers.wrappers.helix.wrap {
      inherit pkgs;
      settings = baseConfig;
      languages = baseLangs pkgs;
      themes = baseThemes;
    };
  };

  flake.modules.nixos.default = {
    config,
    pkgs,
    dotfile,
    ...
  }: {
    options.custom = {
      programs.helix = {
        settings = mkOption {
          type = submodule {freeformType = attrs;};
          description = ''
            Configuration of helix.
            See <https://docs.helix-editor.com/configuration.html>
            for options.
          '';
        };
        languages = mkOption {
          type = submodule {freeformType = attrs;};
          description = ''
            Language-specific settings and settings for language servers.
            See <https://docs.helix-editor.com/languages.html>
            for options.
          '';
        };
      };
    };

    config = {
      nixpkgs.overlays = [
        (_: prev: {
          helix = pkgs.custom.helix.wrap {
            settings = mkForce (
              recursiveUpdate baseConfig
              {
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
              }
              // config.custom.programs.helix.settings
            );
            languages = mkForce (
              recursiveUpdate (baseLangs prev)
              {
                language-server.nixd.config.nixd = let
                  myFlake = ''(builtins.getFlake "${dotfile}")'';
                in {
                  nixos.expr = "import ${myFlake}.inputs.nixpkgs { }";
                  options = {
                    nixos.expr = "${myFlake}.nixosConfigurations.${config.networking.hostName}.options";
                    flake-parts.expr = "${myFlake}.debug.options";
                  };
                };
              }
              // config.custom.programs.helix.languages
            );
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
  };
}
