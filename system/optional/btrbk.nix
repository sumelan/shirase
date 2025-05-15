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
{
  options.custom = with lib; {
    btrbk.enable = mkEnableOption "snapshots using btrbk";
  };

  config = lib.mkIf config.custom.btrbk.enable {
    services.btrbk =
      let
        basicBtrbk = {
          stream_compress = "lz4";
          incremental_resolve = "directory";
          snapshot_create = "onchange";
          # retention policy
          snapshot_preserve_min = "3d";
          snapshot_preserve = "3d";
          target_preserve_min = "no";
          target_preserve = "3d";
        };
      in
      {
        # common setting
        extraPackages = [ pkgs.lz4 ];

        # set instance on client side
        instances = {
          "remote-backup" = lib.mkIf isLaptop {
            onCalendar = "daily";
            settings = basicBtrbk // {
              ssh_user = "btrbk";
              ssh_identity = "/var/lib/btrbk/.ssh/btrbk_key"; # must be readable by user/group btrbk
              volume."/" = {
                group = "remote";
                subvolume = {
                  persist = {
                    group = "remote-persist"; # for command line filtering
                    snapshot_dir = "snapshots";
                    snapshot_name = "persist";
                  };
                };
                target = "ssh://sakura/media/${host}-backups";
              };
            };
          };

          "local-backup" = lib.mkIf isServer {
            onCalendar = "daily";
            settings = basicBtrbk // {
              volume."/" = {
                group = "local";
                subvolume = {
                  persist = {
                    group = "local-persist";
                    snapshot_dir = "snapshots";
                    snapshot_name = "persist";
                  };
                };
                target = "/media/${host}-backups";
              };
            };
          };
        };

        # set ssh command on server side
        sshAccess = lib.mkIf isServer [
          {
            key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFGww+bXaeTXj6s10G4V8Kz2PqGfI6tU4rd8KfxxoQj9 btrbk";
            roles = [
              "target"
              "info"
              "receive"
            ];
          }
        ];
      };

    # notify when service fails
    systemd.services =
      with lib;
      {
        "notify-problems@" = {
          enable = true;
          serviceConfig.User = "${user}";
          environment.SERVICE = "%i";
          script = ''
            export $(cat /proc/$(${pkgs.procps}/bin/pgrep "niri-session" -u "$USER")/environ |grep -z '^DBUS_SESSION_BUS_ADDRESS=')
            ${pkgs.libnotify}/bin/notify-send -u critical "$SERVICE FAILED!" "Run journalctl -xeu $SERVICE for details"
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
    systemd.timers =
      with lib;
      flip mapAttrs' config.services.btrbk.instances (
        name: value:
        nameValuePair "btrbk-${name}" {
          timerConfig.Persistent = lib.mkForce true;
        }
      );

    # only client side
    custom.persist = {
      root = {
        directories = lib.mkIf isLaptop [
          "/var/lib/btrbk/.ssh"
        ];
        cache.directories = [
          "/snapshots"
        ];
      };
    };
  };
}
