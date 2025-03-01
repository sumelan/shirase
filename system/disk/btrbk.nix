{
  lib,
  config,
  pkgs,
  host,
  user,
  isLaptop,
  isServer,
  ...
}:
let
  cfg = config.custom.btrbk;
in
{
  options.custom = with lib; {
    btrbk = {
      enable = mkEnableOption "snapshots using btrbk";
      calendar = mkOption {
        type = types.str;
        default = "daily";
      };
      preserve_min = mkOption {
        type = types.str;
        default = "3d";
      };
      preserve = mkOption {
        type = types.str;
        default = "7d";
      };
      target_preserve = mkOption {
        type = types.str;
        default = "7d";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.btrbk = lib.mkIf isLaptop {
      instances."remote_sakura" = {
        onCalendar = cfg.calendar;
        settings = {
          ssh_user = "${user}";
          ssh_identity = "/home/${user}/.ssh/sakura";
          snapshot_preserve_min = cfg.preserve_min;
          snapshot_preserve = cfg.preserve;
          target_preserve = cfg.target_preserve;
          stream_compress = "lz4";
          volume."/" = {
            target = "ssh://sakura/media/${host}-backups";
            subvolume = "persist";
          };
        };
      };
    };
    environment.systemPackages = lib.mkIf isServer [
      pkgs.lz4
    ];
  };
}
