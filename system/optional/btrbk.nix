{
  lib,
  config,
  pkgs,
  user,
  host,
  isLaptop,
  isServer,
  ...
}:
let
  btrbkRemote = name: {
    onCalendar = "daily";
    settings = {
      ssh_user = "btrbk";
      ssh_identity = "/var/lib/btrbk/.ssh/btrbk_key";
      snapshot_preserve_min = "3d";
      snapshot_preserve = "3d";
      target_preserve = "3d";
      stream_compress = "lz4";
      volume."/" = {
        target = "ssh://sakura/media/${name}-backups";
        subvolume = "persist";
      };
    };
  };

  backupMonitor =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    with lib;
    {
      key = "backupMonitor";
      _file = "backupMonitor";
      config.systemd.services =
        {
          "notify-problems@" = {
            enable = true;
            serviceConfig.User = "${user}";
            environment.SERVICE = "%i";
            script = ''
              export $(cat /proc/$(${pkgs.procps}/bin/pgrep "niri-session" -u "$USER")/environ |grep -z '^DBUS_SESSION_BUS_ADDRESS=')
              ${pkgs.libnotify}/bin/notify-send -u critical "$SERVICE FAILED!" "Run journalctl -u $SERVICE for details"
            '';
          };
        }
        // flip mapAttrs' config.services.btrbk.instances (
          name: value:
          nameValuePair "btrbk-${name}" {
            unitConfig.OnFailure = "notify-problems@%i.service";
            preStart = lib.mkBefore ''
              # waiting for internet after resume-from-suspend
              until ${pkgs.iputils.out}/bin/ping google.com -c1 -q >/dev/null; do :; done
            '';
          }
        );

      # optional, but this actually forces backup after boot in case laptop was powered off during scheduled event
      # for example, if you scheduled backups daily, your laptop should be powered on at 00:00
      config.systemd.timers = flip mapAttrs' config.services.btrbk.instances (
        name: value:
        nameValuePair "btrbk-${name}" {
          timerConfig.Persistent = lib.mkForce true;
        }
      );
    };

in
{
  imports = [ backupMonitor ];

  options.custom = with lib; {
    btrbk = {
      enable = mkEnableOption "snapshots using btrbk";
    };
  };

  config = lib.mkIf config.custom.btrbk.enable {
    # common settings
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

    # client settings
    services.btrbk = lib.mkIf isLaptop {
      instances = {
        "remote_backup" = btrbkRemote "${host}";
      };
    };

    # remote settings
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

    custom.persist = {
      root.directories = [
        "/var/lib/btrbk"
      ];
    };
  };
}
