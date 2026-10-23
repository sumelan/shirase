{
  self,
  config,
  pkgs,
  ...
}: let
  inherit
    (pkgs.lib)
    mkEnableOption
    mkOption
    concatStringsSep
    ;
  inherit (pkgs.lib.types) listOf str;
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
    hjem.users.sumelan.packages = let
      pkg = pkgs.btop.override {
        inherit (config.custom.programs.btop) cudaSupport;
        inherit (config.custom.programs.btop) rocmSupport;
      };

      extraConfig = {
        disks_filter = concatStringsSep " " (
          [
            "/boot"
            "/cache"
            "/persist"
          ]
          ++ config.custom.programs.btop.disks
        );
      };
    in [
      (self.packages.${pkgs.stdenv.hostPlatform.system}.btop.override {inherit pkg extraConfig;})
    ];
  };
}
