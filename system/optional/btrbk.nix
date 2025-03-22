{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.custom.btrbk;
in
{
  options.custom = with lib; {
    btrbk = {
      enable = mkEnableOption "snapshots using btrbk";
      relationShip = mkOption {
        type = types.enum [
          "host"
          "client"
        ];
      };
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
    # clinet side settings
    services.btrbk = lib.mkIf (cfg.relationShip == "client") {
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
            target = "ssh://sakura/media/acer-backups";
            subvolume = "persist";
          };
        };
      };
    };
    # host side settings
    security.sudo = lib.mkIf (cfg.relationShip == "host") {
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

    # common side settings
    environment.systemPackages = [ pkgs.lz4 ];
    users = {
      groups.btrbk = { };
      users.btrbk = {
        isSystemUser = true;
        shell = lib.mkForce pkgs.bash;
        createHome = true;
        home = "/var/lib/btrbk";
        initialPassword = "password";
        hashedPasswordFile = "/persist/etc/shadow/btrbk";
        group = "btrbk";
        openssh.authorizedKeys.keyFiles = [
          ../../hosts/btrbk_key.pub
        ];
      };
    };

    custom.persist = {
      root.directories = [
        "/var/lib/btrbk"
      ];
    };
  };
}
