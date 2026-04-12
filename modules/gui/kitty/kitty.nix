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

  # expose generic kitty package without font, color-theme and SHELL
  perSystem = {pkgs, ...}: {
    packages.kitty = self.wrappers.kitty.wrap {inherit pkgs;};
  };

  flake.modules.nixos.gui = {
    config,
    pkgs,
    ...
  }: let
    nord = pkgs.fetchFromGitHub {
      owner = "connorholyday";
      repo = "nord-kitty";
      rev = "3a819c1f207cd2f98a6b7c7f9ebf1c60da91c9e9";
      hash = "sha256-Zbmrp2sQO0upkQ6Gtt5O4SLzPhovUDQNjvM0x8v2a0g=";
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
                include = "${nord}/nord.conf";
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

        xdg.mime-apps = {
          default-applications = {
            "x-scheme-handler/terminal" = "kitty.desktop";
          };
        };
      };

      custom.programs.print-config = {
        kitty =
          # sh
          ''moor --lang ini "${pkgs.kitty.configuration.flags."--config".data}"'';
      };
    };
  };
}
