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
      wd.enable =
        mkEnableOption "WD Elements 4TB";
      ironwolf.enable =
        mkEnableOption "Seagate IronWolf 2TB";
    };
  };

  config = mkIf cfg.enable {
    fileSystems = {
      "/media/WD4T" = mkIf cfg.wd.enable {
        device = "/dev/disk/by-uuid/45a19415-adfd-4db2-8acb-52c65a6ab421";
        fsType = "btrfs";
        options = [
          "x-systemd.automount"
          "nofail"
        ];
      };
      "/media/IRONWOLF2T" = mkIf cfg.ironwolf.enable {
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
        optional cfg.wd.enable "/media/WD4T"
        ++ optional cfg.ironwolf.enable "/media/IRONWOLF2";
    };

    hm = {
      custom.btop.disks =
        optional cfg.wd.enable "/media/WD4T"
        ++ optional cfg.ironwolf.enable "/media/IRONWOLF2";
    };
  };
}
