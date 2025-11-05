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
      westernDigital.enable =
        mkEnableOption "WD Elements 4TB";
      ironWolf.enable =
        mkEnableOption "Seagate IronWolf 2TB";
    };
  };

  config = mkIf cfg.enable {
    fileSystems = {
      "/media/WD4T" = mkIf cfg.westernDigital.enable {
        device = "/dev/disk/by-uuid/45a19415-adfd-4db2-8acb-52c65a6ab421";
        fsType = "btrfs";
        options = [
          "x-systemd.automount"
          "nofail"
        ];
      };
      "/media/IRONWOLF2T" = mkIf cfg.ironWolf.enable {
        device = "/dev/disk/by-uuid/4f2f9123-984f-4f89-abdc-2fb67623f9d8";
        fsType = "btrfs";
        options = [
          "x-systemd.automount"
          "nofail"
        ];
      };
    };

    services.btrfs.autoScrub = {
      fileSystems =
        optional cfg.westernDigital.enable "/media/WD4T"
        ++ optional cfg.ironWolf.enable "/media/IRONWOLF2";
    };

    hm = {
      custom.btop.disks =
        optional cfg.westernDigital.enable "/media/WD4T"
        ++ optional cfg.ironWolf.enable "/media/IRONWOLF2";
    };
  };
}
