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
  wdelem = "/media/4TWD";
  ironwolf = "/media/IRONWOLF2";
in {
  options.custom = {
    hdds = {
      enable = mkEnableOption "Desktop HDDs";
      wdelem4 =
        mkEnableOption "WD Elements 4TB"
        // {
          default = config.custom.hdds.enable;
        };
      ironwolf2 =
        mkEnableOption "Seagate IronWolf 2TB"
        // {
          default = config.custom.hdds.enable;
        };
    };
  };

  config = mkIf cfg.enable {
    services.sanoid = {
      datasets = {
        "zfs-4twd-1/media" = mkIf cfg.wdelem4 {
          hourly = 3;
          daily = 10;
          weekly = 2;
          monthly = 0;
        };
        "zfs-ironwolf-1/media" = mkIf cfg.ironwolf2 {
          hourly = 3;
          daily = 10;
          weekly = 2;
          monthly = 0;
        };
      };
    };

    hm = {
      custom.btop.disks =
        optional cfg.wdelem4 wdelem ++ optional cfg.ironwolf2 ironwolf;
    };

    fileSystems = {
      "/media/4TWD" = mkIf cfg.wdelem4 {
        device = "zfs-4twd-1/media";
        fsType = "zfs";
      };
      "/media/IRONWOLF2" = mkIf cfg.ironwolf2 {
        device = "zfs-ironwolf-1/media";
        fsType = "zfs";
      };
    };
  };
}
