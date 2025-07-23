{
  lib,
  config,
  isServer,
  ...
}:
let
  cfg = config.custom.hdds;
  wdelem = "/media/4TWD";
  ironwolf = "/media/IRONWOLF2";
in
{
  options.custom = {
    hdds = {
      enable = lib.mkEnableOption "Desktop HDDs" // {
        default = isServer;
      };
      wdelem4 = lib.mkEnableOption "WD Elements 4TB" // {
        default = config.custom.hdds.enable;
      };
      ironwolf2 = lib.mkEnableOption "Seagate IronWolf 2TB" // {
        default = config.custom.hdds.enable;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    fileSystems = {
      ${wdelem} = lib.mkIf cfg.wdelem4 {
        device = "/dev/disk/by-uuid/40c7dc3e-a8ee-41ed-a30d-52eb8d24e425";
        fsType = "btrfs";
        options = [
          "x-systemd.automount"
          "nofail"
        ];
      };
      ${ironwolf} = lib.mkIf cfg.ironwolf2 {
        device = "/dev/disk/by-uuid/96be0981-9995-4c3e-beb4-6ba049d37d7e";
        fsType = "btrfs";
        options = [
          "x-systemd.automount"
          "nofail"
        ];
      };
    };

    hm = {
      custom.btop.disks =
        lib.optionals cfg.wdelem4 [ wdelem ] ++ lib.optionals cfg.ironwolf2 [ ironwolf ];
    };
  };
}
