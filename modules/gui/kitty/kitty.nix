{
  lib,
  self,
  ...
}: let
  inherit (lib) getExe mkOption mkDefault;
  inherit (lib.generators) toKeyValue mkKeyValueDefault;

  kittyOptions = pkgs: {
    extraSettings = mkOption {
      inherit (pkgs.formats.keyValue {}) type;
      default = {};
      description = ''
        Options to add to {file}`kitty.conf` file.
        See <https://sw.kovidgoyal.net/kitty/conf/>
        for options.
      '';
    };
  };

  baseKittyConf = import ./_config.nix {};
in {
  flake.wrappers.kitty = {
    config,
    wlib,
    ...
  }: let
    toKittyConf = toKeyValue {
      listsAsDuplicateKeys = true;
      mkKeyValue = mkKeyValueDefault {} " ";
    };
  in {
    imports = [wlib.modules.default];

    options =
      (kittyOptions config.pkgs)
      // {
        "kitty.conf" = mkOption {
          type = wlib.types.file config.pkgs;
          default.content = toKittyConf (baseKittyConf // config.extraSettings);
          visible = false;
        };
      };

    config.package = mkDefault config.pkgs.kitty;
    config.flags = {
      "--config" = toString config."kitty.conf".path;
    };
  };

  flake.modules.nixos.kitty = {
    config,
    pkgs,
    ...
  }: let
    catppuccin-frappe = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "kitty";
      rev = "43098316202b84d6a71f71aaf8360f102f4d3f1a";
      hash = "sha256-akRkdq8l2opGIg3HZd+Y4eky6WaHgKFQ5+iJMC1bhnQ=";
    };
    fishPath = getExe config.programs.fish.package;
  in {
    options.custom = {
      programs.kitty = kittyOptions pkgs;
    };

    config = {
      nixpkgs.overlays = [
        (_: prev: {
          kitty = self.wrappers.kitty.wrap {
            pkgs = prev;
            extraSettings =
              {
                # SHELL
                env = "SHELL=${fishPath}";
                shell = fishPath;
                # font
                font_family = config.custom.fonts.monospace;
                # color theme
                include = "${catppuccin-frappe}/themes/frappe.conf";
              }
              // config.custom.programs.kitty.extraSettings;
          };
        })
      ];

      environment.shellAliases = {
        # change color on ssh
        ssh = "kitten ssh --kitten=color_scheme='Rosé Pine Moon'";
      };

      hj = {
        packages = [
          pkgs.kitty # overlay-ed above
        ];
      };

      custom.programs.print-config = {
        kitty =
          # sh
          ''moor --lang ini "${pkgs.kitty.configuration.flags."--config".data}"'';
      };
    };
  };
}
