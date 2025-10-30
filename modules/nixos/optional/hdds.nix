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
in {
  options.custom = {
    hdds = {
      enable = mkEnableOption "Desktop HDDs";
      wd =
        mkEnableOption "WD Elements 4TB";
      ironwolf =
        mkEnableOption "Seagate IronWolf 2TB";
    };
  };

  config = mkIf cfg.enable {
    fileSystems = {
      "/media/WD4T" = mkIf cfg.wd {
        device = "elements4T-1";
        fsType = "btrfs";
        options = [
          "x-systemd.automount"
          "nofail"
        ];
      };
      "/media/IRONWOLF2T" = mkIf cfg.ironwolf {
        device = "ironwolf2T-1";
        fsType = "btrfs";
        options = [
          "x-systemd.automount"
          "nofail"
        ];
      };
    };

    services.btrfs.autoScrub = {
      fileSystems =
        optional cfg.wd "/media/WD4T"
        ++ optional cfg.ironwolf "/media/IRONWOLF2";
    };

    hm = {
      custom.btop.disks =
        optional cfg.wd "/media/WD4T"
        ++ optional cfg.ironwolf "/media/IRONWOLF2";
    };
  };
}
