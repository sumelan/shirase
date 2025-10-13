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
        mkEnableOption "WD Elements 4TB"
        // {
          default = config.custom.hdds.enable;
        };
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
    };

    services.btrfs.autoScrub = {
      fileSystems =
        optional cfg.wd "/media/WD4T";
    };

    hm = {
      custom.btop.disks =
        optional cfg.wd "/media/WD4T";
    };
  };
}
