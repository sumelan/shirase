{lib, ...}: let
  inherit
    (lib)
    mkOption
    mkIf
    optional
    ;
  inherit (lib.types) bool;
in {
  flake.modules.nixos.hdds = {config, ...}: let
    cfg = config.custom.hardware.hdds;
  in {
    options.custom = {
      hardware.hdds = {
        westernDigital = mkOption {
          type = bool;
          description = "WD Elements 4TB";
          default = false;
        };
        ironWolf = mkOption {
          type = bool;
          description = "Seagate IronWolf 2TB";
          default = false;
        };
      };
    };

    config = {
      boot.zfs.extraPools =
        optional cfg.westernDigital "WD4T"
        ++ optional cfg.ironWolf "IW2T";

      services.sanoid = {
        datasets = {
          # mountpoint=/media/WD4T
          "WD4T/media" = mkIf cfg.westernDigital {
            hourly = 3;
            daily = 10;
            weekly = 2;
            monthly = 0;
          };
          # mountpoint=/backups
          "IW2T" = mkIf cfg.ironWolf {
            recursive = true;
            hourly = 3;
            daily = 10;
            weekly = 2;
            monthly = 0;
          };
        };
      };

      custom.programs.btop.disks =
        optional cfg.westernDigital "/media/WD4T"
        ++ optional cfg.ironWolf "/backups";
    };
  };
}
