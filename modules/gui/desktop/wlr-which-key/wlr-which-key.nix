{
  lib,
  self,
  ...
}: let
  inherit (builtins) readFile;
  inherit (lib) mkOption mkDefault concatStringsSep;

  yamlFmt = pkgs: pkgs.formats.yaml {};

  wlrOptions = pkgs: {
    extraSettings = mkOption {
      inherit (yamlFmt pkgs) type;
      default = {};
      description = ''
        Configuration for wlr-which-key.
        See <https://github.com/MaxVerevkin/wlr-which-key>
      '';
    };
  };

  baseWlrConf = import ./_config.nix {};
in {
  flake.wrappers.wlr-which-key = {
    config,
    wlib,
    ...
  }: {
    imports = [wlib.modules.default];

    options =
      wlrOptions config.pkgs
      // {
        "wlr-which-key.yaml" = mkOption {
          type = wlib.types.file config.pkgs;
          default.path = (yamlFmt config.pkgs).generate "wlr-which-key.yaml" (baseWlrConf // config.extraSettings);
          visible = false;
        };
      };

    config.package = mkDefault config.pkgs.wlr-which-key;

    config.addFlag = [config.constructFiles.generatedConfig.path];

    config.constructFiles.generatedConfig = {
      content = readFile config."wlr-which-key.yaml".path;
      relPath = "wlr-which-key.yaml";
    };
  };

  flake.modules.nixos.gui = {
    config,
    pkgs,
    ...
  }: {
    options.custom = {
      programs.wlr-which-key = wlrOptions pkgs;
    };

    config = {
      nixpkgs.overlays = [
        (_: prev: {
          wlr-which-key = self.wrappers.wlr-which-key.wrap {
            pkgs = prev;
            extraSettings =
              {
                font = concatStringsSep " " [
                  config.custom.fonts.monospace
                  "Bold"
                  "Italic"
                  "14"
                ];
              }
              // config.custom.programs.wlr-which-key.extraSettings;
          };
        })
      ];

      hj.packages = [
        pkgs.wlr-which-key # overlay-ed above
      ];

      custom.programs.print-config = {
        wlr-which-key =
          # sh
          ''moor --lang yaml "${pkgs.wlr-which-key.configuration.constructFiles.generatedConfig.outPath}"'';
      };
    };
  };
}
