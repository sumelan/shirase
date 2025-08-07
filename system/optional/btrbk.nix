{
  lib,
  config,
  pkgs,
  user,
  host,
  isLaptop,
  isServer,
  ...
}: let
  retentionPolicy = {
    stream_compress = "lz4";
    snapshot_create = "onchange";
    snapshot_preserve_min = "7d";
    snapshot_preserve = "7d 4w";
    target_preserve_min = "no";
    target_preserve = "7d 4w";
  };
in {
  options.custom = {
    btrbk.enable =
      lib.mkEnableOption "Tool for snapshots and remote backups"
      // {
        default = true;
      };
  };

  config = lib.mkIf config.custom.btrbk.enable (
    lib.mkMerge [
      # common setting
      # add extra packages on both clinet and server
      {
        services.btrbk.extraPackages = [pkgs.lz4];
      }

      # client settings
      # set remote instances and systemd service that will notify when backup fails
      # plus, add the ssh directory to persist
      (lib.optionalAttrs isLaptop {
        services.btrbk.instances = {
          "remote-backup" = {
            onCalendar = "daily";
            settings =
              retentionPolicy
              // {
                ssh_user = "btrbk";
                ssh_identity = "/var/lib/btrbk/.ssh/btrbk_key"; # must be readable by user/group btrbk
                volume."/" = {
                  group = "remote";
                  subvolume = {
                    "persist" = {
                      group = "remote-persist"; # for command line filtering
                      snapshot_dir = "/cache/snapshots";
                      snapshot_name = "persist";
                    };
                  };
                  target = "ssh://sakura/media/4TWD/${host}-remote";
                };
              };
          };
        };

        systemd.services = with lib;
          {
            "notify-problems@" = {
              enable = true;
              serviceConfig.User = user;
              environment.SERVICE = "%i";
              script = ''
                export $(cat /proc/$(${pkgs.procps}/bin/pgrep "niri --session" -u "$USER")/environ |grep -z '^DBUS_SESSION_BUS_ADDRESS=')
                ${pkgs.libnotify}/bin/notify-send -u critical "$SERVICE FAILED!" "Run journalctl -xeu $SERVICE for details"
              '';
            };
          }
          // flip mapAttrs' config.services.btrbk.instances (
            name: _value:
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
        systemd.timers = with lib;
          flip mapAttrs' config.services.btrbk.instances (
            name: _value:
              nameValuePair "btrbk-${name}" {
                timerConfig.Persistent = lib.mkForce true;
              }
          );

        custom.persist = {
          root = {
            directories = [
              "/var/lib/btrbk/.ssh"
            ];
          };
        };
      })

      # server setting
      # add ssh key to perform btrfs command
      (lib.optionalAttrs isServer {
        services.btrbk.sshAccess = [
          {
            key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFGww+bXaeTXj6s10G4V8Kz2PqGfI6tU4rd8KfxxoQj9 btrbk";
            roles = [
              "target"
              "info"
              "receive"
              "delete"
            ];
          }
        ];
      })
    ]
  );
}
