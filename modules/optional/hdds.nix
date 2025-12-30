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
        device = "zusb-wd4T/media";
        fsType = "zfs";
        options = [
          "x-systemd.automount"
          "nofail"
        ];
      };
      "/media/IW2T" = mkIf cfg.ironWolf {
        device = "zusb-iw2T/backups";
        fsType = "zfs";
        options = [
          "x-systemd.automount"
          "nofail"
        ];
      };
    };
    services.sanoid = {
      datasets = {
        "zusb-wd4T/media" = mkIf cfg.westernDigital {
          hourly = 3;
          daily = 10;
          weekly = 2;
          monthly = 0;
        };
        "zusb-iw2T/backups" = mkIf cfg.ironWolf {
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
        ++ optional cfg.ironWolf "/media/IW2T";
    };
  };
}
