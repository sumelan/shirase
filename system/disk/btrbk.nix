{
  lib,
  config,
  pkgs,
  host,
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
          ssh_user = "btrbk";
          ssh_identity = "/var/lib/btrbk/.ssh/btrbk_key";
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
    security.sudo = lib.mkIf isServer {
      extraRules = [
        {
          users = [ "btrbk" ];
          commands = [
            {
              command = "${config.system.path}/bin/test";
              options = [ "NOPASSWD" ];
            }
            {
              command = "${config.system.path}/bin/readlink";
              options = [ "NOPASSWD" ];
            }
            {
              command = "${config.system.path}/bin/btrfs";
              options = [ "NOPASSWD" ];
            }
          ];
        }
      ];
    };
    environment.systemPackages = [ pkgs.lz4 ];

    users = {
      groups.btrbk = {};
      users.btrbk = {
        isSystemUser = true;
        shell = lib.mkIf isServer pkgs.bash;
        createHome = true;
        home = "/var/lib/btrbk";
        initialPassword = "password";
        hashedPasswordFile = "/persist/etc/shadow/btrbk";
        group = "btrbk";
      };
    };

    custom.persist = {
      root.directories = [
        "/var/lib/btrbk"
      ];
    };
  };
}
