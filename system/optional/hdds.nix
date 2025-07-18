{
  lib,
  config,
  ...
}:
let
  cfg = config.custom.hdds;
in
{
  options.custom = {
    hdds = {
      enable = lib.mkEnableOption "Desktop HDDs";
      wdelem4 = lib.mkEnableOption "WD Elements 4TB" // {
        default = config.custom.hdds.enable;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    fileSystems = {
      "/media" = lib.mkIf cfg.wdelem4 {
        device = "/dev/disk/by-uuid/0769e0fe-da50-4eab-9ee8-b08e9dddcfe7";
        fsType = "btrfs";
        options = [
          "x-systemd.automount"
          "nofail"
        ];
      };
    };

    hm.custom.btop.disks = lib.optional cfg.wdelem4 "/media";
  };
}
