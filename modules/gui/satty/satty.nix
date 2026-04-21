{
  lib,
  self,
  ...
}: let
  inherit (builtins) listToAttrs;
  inherit (lib) mkOption mkDefault;

  baseSattyConf = import ./_config.nix {};
in {
  flake.wrappers.satty = {
    config,
    wlib,
    ...
  }: let
    tomlFormat = config.pkgs.formats.toml {};
    sattyOptions = {
      extraSettings = mkOption {
        inherit (tomlFormat) type;
        default = {};
        example = {
          fullscreen = false;
          early-exit = true;
        };
        description = ''
          Options to add to {file}`satty.toml` file.
          See <https://github.com/Satty-org/Satty?tab=readme-ov-file#configuration-file>
          for options.
        '';
      };
    };
  in {
    imports = [wlib.modules.default];

    options =
      sattyOptions
      // {
        "satty.toml" = mkOption {
          type = wlib.types.file config.pkgs;
          default.path = tomlFormat.generate "satty.toml" (baseSattyConf // config.extraSettings);
          visible = false;
        };
      };

    config.package = mkDefault config.pkgs.satty;
    config.flags = {
      "--config" = toString config."satty.toml".path;
    };
  };

  flake.modules.nixos.gui = {
    config,
    pkgs,
    ...
  }: let
    tomlFormat = pkgs.formats.toml {};
    pictures = "${config.hj.directory}/Pictures";
    sattyOptions = {
      extraSettings = mkOption {
        inherit (tomlFormat) type;
        default = {};
        example = {
          fullscreen = false;
          early-exit = true;
        };
        description = ''
          Options to add to {file}`satty.toml` file.
          See <https://github.com/Satty-org/Satty?tab=readme-ov-file#configuration-file>
          for options.
        '';
      };
    };
  in {
    options.custom = {
      programs.satty = sattyOptions;
    };

    config = {
      nixpkgs.overlays = [
        (_: prev: {
          satty = self.wrappers.satty.wrap {
            pkgs = prev;
            extraSettings =
              {
                general.output-filename = "${pictures}/Satty/%Y-%m-%d_%H-%M-%S.png";
                color-palette.palette = [
                  "#303446"
                  "#626880"
                  "#F2D5CF"
                  "#8CAAEE"
                  "#A6D189"
                  "#81C8BE"
                  "#E78284"
                  "#EA999C"
                  "#F4B8E4"
                  "#E5C890"
                ];
              }
              // config.custom.programs.satty.extraSettings;
          };
        })
      ];

      hj = {
        packages = [
          pkgs.satty # overlayy-ed above
        ];

        xdg.mime-apps = let
          value = "satty.desktop";
          associations = listToAttrs (map (name: {
              inherit name value;
            }) [
              "image/jpeg"
              "image/gif"
              "image/webp"
              "image/png"
            ]);
        in {
          # remove `satty.desktop` from image mimetypes
          removed-associations = associations;
        };
      };

      custom.programs.print-config = {
        satty =
          # sh
          ''moor --lang toml "${pkgs.satty.configuration.flags."--config".data}"'';
      };
    };
  };
}
