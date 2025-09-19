{
  lib,
  config,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    optional
    ;

  cfg = config.custom.hdds;
  elements = "/media/WD4T";
  ironwolf = "/media/IRONWOLF2T";
in {
  options.custom = {
    hdds = {
      enable = mkEnableOption "Desktop HDDs";
      wd =
        mkEnableOption "WD Elements 4TB"
        // {
          default = config.custom.hdds.enable;
        };
      ironwolf =
        mkEnableOption "Seagate IronWolf 2TB"
        // {
          default = config.custom.hdds.enable;
        };
    };
  };

  config = mkIf cfg.enable {
    services.sanoid = {
      datasets = {
        "zfs-elements4T-1/media" = mkIf cfg.wd {
          hourly = 3;
          daily = 10;
          weekly = 2;
          monthly = 0;
        };
        "zfs-ironwolf2T-1/media" = mkIf cfg.ironwolf {
          hourly = 3;
          daily = 10;
          weekly = 2;
          monthly = 0;
        };
      };
    };

    hm = {
      custom.btop.disks =
        optional cfg.wd elements ++ optional cfg.ironwolf ironwolf;
    };

    fileSystems = {
      "/media/WD4T" = mkIf cfg.wd {
        device = "zfs-elements4T-1/media";
        fsType = "zfs";
      };
      "/media/IRONWOLF2T" = mkIf cfg.ironwolf {
        device = "zfs-ironwolf2T-1/media";
        fsType = "zfs";
      };
    };
  };
}
