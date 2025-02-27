{
  lib,
  config,
  ...
}:
let
  cfg = config.custom.hdds;
in
{
  options.custom = with lib; {
    hdds = {
      enable = mkEnableOption "Desktop HDDs";
      wdelem4 = mkEnableOption "WD Elements 4TB" // {
        default = config.custom.hdds.enable;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    fileSystems = {
      "/media/wdelem4" = lib.mkIf cfg.wdelem4 {
        device = "/dev/disk/by-uuid/ec8537bb-a73a-4ea5-8282-dcc6e6af1d95";
        fsType = "btrfs";
        options = [ "nofail" "x-systemd.automount" ];
      };
    };
  };
}
