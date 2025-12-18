{
  lib,
  config,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkOption
    mkIf
    optional
    ;
  inherit (lib.types) bool;
  cfg = config.custom.hdds;
in {
  options.custom = {
    hdds = {
      enable = mkEnableOption "Desktop HDDs";
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

  config = mkIf cfg.enable {
    fileSystems = {
      "/media/WD4T" = mkIf cfg.westernDigital {
        device = "zfs-elements4T-1/media";
        fsType = "zfs";
        options = [
          "x-systemd.automount"
          "nofail"
        ];
      };
      "/media/IRONWOLF2T" = mkIf cfg.ironWolf {
        device = "zfs-ironwolf2T-1/media";
        fsType = "zfs";
        options = [
          "x-systemd.automount"
          "nofail"
        ];
      };
    };
    services.sanoid = {
      datasets = {
        "zfs-elements4T-1/media" = mkIf cfg.westernDigital {
          hourly = 3;
          daily = 10;
          weekly = 2;
          monthly = 0;
        };
        "zfs-ironwolf2T-1/media" = mkIf cfg.ironWolf {
          hourly = 3;
          daily = 10;
          weekly = 2;
          monthly = 0;
        };
      };
    };

    hm = {
      custom.btop.disks =
        optional cfg.westernDigital "/media/WD4T"
        ++ optional cfg.ironWolf "/media/IRONWOLF2T";
    };
  };
}
