{
  config,
  lib,
  ...
}: let
  inherit (config) flake;
  inherit (lib) mkEnableOption mkOption;
  inherit (lib.types) listOf str;
  inherit (flake.custom.wrappers) mkBtop;
in {
  flake.custom.hjemConfigs.btop = {
    config,
    pkgs,
    user,
    ...
  }: let
    pkg = pkgs.btop.override {
      inherit (config.custom.programs.btop) cudaSupport;
      inherit (config.custom.programs.btop) rocmSupport;
    };
    extraConfig = {
      disks_filter = lib.concatStringsSep " " (
        [
          "/"
          "/boot"
          "/persist"
        ]
        ++ config.custom.programs.btop.disks
      );
    };
  in {
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
      hjem.users.${user}.packages = [
        (mkBtop {inherit pkgs pkg extraConfig;})
      ];
    };
  };
}
