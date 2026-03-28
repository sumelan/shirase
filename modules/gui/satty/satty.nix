{
  inputs,
  lib,
  self,
  ...
}: let
  inherit (builtins) listToAttrs;
  inherit (lib) mkOption mkDefault;
in {
  flake.wrapperModules.satty = inputs.wrappers.lib.wrapModule (
    {
      config,
      wlib,
      ...
    }: let
      inherit (wlib.types) file;
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

      baseSattyConf = import ./_config.nix {};
    in {
      options =
        sattyOptions
        // {
          "satty.toml" = mkOption {
            type = file config.pkgs;
            default.path = tomlFormat.generate "satty.toml" (baseSattyConf // config.extraSettings);
            visible = false;
          };
        };

      config.package = mkDefault config.pkgs.satty;
      config.flags = {
        "--config" = toString config."satty.toml".path;
      };
    }
  );

  # expose generic sattyy package without output file and color-palette
  perSystem = {pkgs, ...}: {
    packages.satty = (self.wrapperModules.satty.apply {inherit pkgs;}).wrapper;
  };

  flake.modules = {
    nixos.default = {
      config,
      pkgs,
      ...
    }: let
      tomlFormat = pkgs.formats.toml {};
      inherit (config.hm.xdg.userDirs) pictures;
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
            satty =
              (self.wrapperModules.satty.apply {
                pkgs = prev;
                extraSettings =
                  {
                    general.output-filename = "${pictures}/Satty/%Y-%m-%d_%H-%M-%S.png";
                    color-palette.palette = [
                      "#191D24"
                      "#434C5E"
                      "#ECEFF4"
                      "#5E81AC"
                      "#8FBCBB"
                      "#A3BE8C"
                      "#BF616A"
                      "#D08770"
                      "#B48EAD"
                      "#EBCB8B"
                    ];
                  }
                  // config.custom.programs.satty.extraSettings;
              }).wrapper;
          })
        ];
      };
    };

    homeManager.default = {pkgs, ...}: {
      home.packages = [
        pkgs.satty # overlayy-ed above
      ];

      xdg.mimeApps = let
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
        associations.removed = associations;
      };

      custom.programs.print-config = {
        satty =
          # sh
          ''moor --lang toml "${pkgs.satty.flags."--config"}"'';
      };
    };
  };
}
