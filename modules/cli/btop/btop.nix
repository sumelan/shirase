{
  inputs,
  lib,
  ...
}: let
  inherit (lib) mkOption mkForce mkEnableOption concatStringsSep;
  inherit (lib.types) listOf str submodule attrs;

  baseBtopConf = import ./_config.nix {};
in {
  perSystem = {pkgs, ...}: {
    packages.btop = inputs.wrappers.wrappers.btop.wrap {
      inherit pkgs;
      settings = baseBtopConf;
    };
  };

  flake.modules.nixos.default = {
    config,
    pkgs,
    ...
  }: {
    options.custom = {
      programs.btop = {
        cudaSupport = mkEnableOption {
          description = "Enable nvidia support for btop";
        };

        rocmSupport = mkEnableOption {
          description = "Enable radeon support for btop";
        };
        settings = mkOption {
          type = submodule {freeformType = attrs;};
          description = ''
            Btop settings.
            See <https://github.com/aristocratos/btop#configurability>
            for available options
          '';
        };
        # convenience option to add disks to btop
        disks = mkOption {
          type = listOf str;
          default = [];
          description = "List of disks to monitor in btop";
        };
      };
    };
    config = {
      nixpkgs.overlays = [
        (_: prev: {
          btop = pkgs.custom.btop.wrap {
            package = prev.btop.override {
              inherit (config.custom.programs.btop) cudaSupport;
              inherit (config.custom.programs.btop) rocmSupport;
            };
            settings = mkForce (
              baseBtopConf
              // {
                color_theme = "catppuccin-frappe";
                disks_filter = concatStringsSep " " (
                  [
                    "/"
                    "/boot"
                    "/persist"
                  ]
                  ++ config.custom.programs.btop.disks
                );
              }
              // config.custom.programs.btop.settings
            );
            themes = import ./_theme.nix {};
          };
        })
      ];

      hj.packages = [
        pkgs.btop # overlay-ed above
      ];

      custom.programs.print-config = {
        btop =
          # sh
          ''moor --lang ini "${pkgs.btop.configuration.passthru.generatedConfig}"'';
      };
    };
  };
}
