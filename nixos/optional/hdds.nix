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
    fileSystems = {
      "/media/WD4T" = mkIf cfg.wd {
        device = "btrfs-elements4T-1/media";
        fsType = "btrfs";
        options = [
          "x-systemd.automount"
          "nofail"
        ];
      };
      "/media/IRONWOLF2T" = mkIf cfg.ironwolf {
        device = "btrfs-ironwolf2T-1/media";
        fsType = "btrfs";
        options = [
          "x-systemd.automount"
          "nofail"
        ];
      };
    };

    services.btrfs.autoScrub = {
      fileSystems = [
        (mkIf cfg.wd "/media/4TWD")
        (mkIf cfg.ironwolf "/media/IRONWOLF2")
      ];
    };

    hm = {
      custom.btop.disks =
        optional cfg.wd elements ++ optional cfg.ironwolf ironwolf;
    };
  };
}
