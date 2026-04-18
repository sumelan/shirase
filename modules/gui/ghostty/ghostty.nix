{
  lib,
  self,
  ...
}: let
  inherit (lib) getExe mkOption mkDefault;
  inherit (lib.generators) toKeyValue mkKeyValueDefault;

  ghosttyOptions = pkgs: {
    extraSettings = mkOption {
      inherit (pkgs.formats.keyValue {}) type;
      default = {};
      description = ''
        Configuration for the Ghostty terminal emulator.
        See <https://ghostty.org/docs/config/reference>
      '';
    };
  };

  baseGhosttyConf = import ./_config.nix {};
in {
  flake.wrappers.ghostty = {
    config,
    wlib,
    ...
  }: let
    toGhosttyConf = toKeyValue {
      listsAsDuplicateKeys = true;
      mkKeyValue = mkKeyValueDefault {} " = ";
    };
  in {
    imports = [wlib.modules.default];

    options =
      (ghosttyOptions config.pkgs)
      // {
        "ghostty.conf" = mkOption {
          type = wlib.types.file config.pkgs;
          default.content = toGhosttyConf (baseGhosttyConf // config.extraSettings);
          visible = false;
        };
      };

    config.package = mkDefault config.pkgs.ghostty;
    config.flags = {
      "--config-file" = toString config."ghostty.conf".path;
    };
    config.flagSeparator = "=";
  };

  flake.modules.nixos.gui = {
    config,
    pkgs,
    ...
  }: let
    fishPath = getExe config.programs.fish.package;
  in {
    options.custom = {
      programs.ghostty = ghosttyOptions pkgs;
    };

    config = {
      nixpkgs.overlays = [
        (_: prev: {
          ghostty = self.wrappers.ghostty.wrap {
            pkgs = prev;
            extraSettings =
              {
                # SHELL
                command = "SHELL=${fishPath} fish";
                # font
                font-family = config.custom.fonts.monospace;
                # color theme
                theme = "Catppuccin Frappe";
              }
              // config.custom.programs.ghostty.extraSettings;
          };
        })
      ];

      hj = {
        packages = [
          pkgs.ghostty # overlay-ed above
        ];

        xdg = {
          config.files."ghostty/config" = {
            permissions = "666";
            text = "";
            type = "copy";
          };

          mime-apps = {
            default-applications = {
              "x-scheme-handler/terminal" = "com.mitchellh.ghostty.desktop";
            };
          };
        };
      };

      custom.programs.print-config = {
        ghostty =
          # sh
          ''moor --lang ini "${pkgs.ghostty.configuration.flags."--config-file".data}"'';
      };
    };
  };
}
