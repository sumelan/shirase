{
  lib,
  self,
  ...
}: let
  inherit (lib) mkOption mkEnableOption concatStringsSep;
  inherit (lib.types) listOf str;

  baseBtopConf = import ./_config.nix {};
in {
  flake.wrappers.btop = {wlib, ...}: {
    imports = [wlib.wrapperModules.btop];

    settings = baseBtopConf;
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
          btop = self.wrappers.btop.wrap {
            pkgs = prev;
            package = prev.btop.override {
              inherit (config.custom.programs.btop) cudaSupport;
              inherit (config.custom.programs.btop) rocmSupport;
            };
            settings =
              baseBtopConf
              // {
                disks_filter = concatStringsSep " " (
                  [
                    "/"
                    "/boot"
                    "/persist"
                  ]
                  ++ config.custom.programs.btop.disks
                );
              };
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
