{
  inputs,
  lib,
  ...
}: let
  inherit (lib) mkOption mkForce concatStringsSep;
  inherit (lib.types) submodule attrs;

  baseWlrConf = import ./_config.nix {};
in {
  perSystem = {pkgs, ...}: {
    packages.wlr-which-key = inputs.wrappers.wrappers.wlr-which-key.wrap {
      inherit pkgs;
      initialKeys = "";
      settings = baseWlrConf;
    };
  };

  flake.modules.nixos.gui = {
    config,
    pkgs,
    ...
  }: {
    options.custom = {
      programs.wlr-which-key = {
        settings = mkOption {
          type = submodule {freeformType = attrs;};
          description = ''
            Configuration for wlr-which-key.
            See <https://github.com/MaxVerevkin/wlr-which-key>
          '';
        };
      };
    };

    config = {
      nixpkgs.overlays = [
        (_: _prev: {
          wlr-which-key = pkgs.custom.wlr-which-key.wrap {
            settings = mkForce (
              baseWlrConf
              // {
                font = concatStringsSep " " [
                  config.custom.fonts.monospace
                  "Bold"
                  "Italic"
                  "14"
                ];
              }
              // config.custom.programs.wlr-which-key.settings
            );
          };
        })
      ];

      hj.packages = [
        pkgs.wlr-which-key # overlay-ed above
      ];

      # print-config is broken due to yaml format
    };
  };
}
