{
  lib,
  config,
  pkgs,
  user,
  host,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    flip
    mkBefore
    mkForce
    mapAttrs'
    nameValuePair
    ;
  cfg = config.custom.btrbk;
in {
  options.custom = {
    btrbk = {
      enable = mkEnableOption "Tool for snapshots and remote backups";
      local.enable = mkEnableOption "Local regular snapshots (time-machine)";
      usb.enable = mkEnableOption "Backups to USB disk";
      remote.enable = mkEnableOption "Host-initiated backup on fileserver";
    };
  };

  config = mkIf cfg.enable {
    services.btrbk = {
      # add extra packages on both clinet and server
      extraPackages = [pkgs.lz4];

      instances = let
        retentionPolicy = {
          stream_compress = "lz4";
          snapshot_create = "onchange";
          snapshot_preserve_min = "7d";
          snapshot_preserve = "7d 4w";
          target_preserve_min = "no";
          target_preserve = "7d 4w";
        };
      in {
        "local" = mkIf cfg.local.enable {
          onCalendar = "hourly";
          settings =
            retentionPolicy
            // {
              volume."/" = {
                group = "local";
                subvolume = {
                  "persist" = {
                    group = "local-persist"; # for command line filtering
                    snapshot_dir = "/snapshots";
                    snapshot_name = "persist";
                  };
                };
              };
            };
        };
        "usb" = mkIf cfg.usb.enable {
          onCalendar = "hourly";
          settings =
            {
              # Create snapshots only if the backup disk is attached
              snapshot_create = "ondemand";
            }
            // retentionPolicy
            // {
              volume."/" = {
                group = "usb";
                subvolume = {
                  "persist" = {
                    group = "usb-persist"; # for command line filtering
                    snapshot_dir = "/snapshots";
                    snapshot_name = "persist";
                  };
                };
                target = "/media/WD4T/snapshots/${host}-local";
              };
            };
        };
        # NOTE: run ssh command as user:btrbk once
        # before start service for the first time
        # `ssh -i '/var/lib/btrbk/.ssh/id_ed25519' btrbk@sakura 'cat /proc/self/mountinfo'`
        "remote" = mkIf cfg.remote.enable {
          onCalendar = "daily";
          settings =
            retentionPolicy
            // {
              ssh_user = "btrbk";
              # must be readable by user/group btrbk
              ssh_identity = "/var/lib/btrbk/.ssh/id_ed25519";
              volume."/" = {
                group = "remote";
                subvolume = {
                  "persist" = {
                    group = "remote-persist"; # for command line filtering
                    snapshot_dir = "/snapshots";
                    snapshot_name = "persist";
                  };
                };
                target = "ssh://sakura/media/WD4T/snapshots/${host}-remote";
              };
            };
        };
      };
      sshAccess = [
        {
          key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMy/TE68lwvJBZ2oiWWQeP/6qTYKrphrYYbLdwYXfeIL btrbk";
          roles = [
            "target"
            "info"
            "receive"
            "delete"
          ];
        }
      ];
    };

    systemd = {
      # set systemd service that will notify when backup fails
      services =
        {
          "notify-problems@" = {
            enable = true;
            serviceConfig.User = user;
            environment.SERVICE = "%i";
            script =
              # sh
              ''
                export $(cat /proc/$(${pkgs.procps}/bin/pgrep "niri-session" -u "$USER")/environ |grep -z '^DBUS_SESSION_BUS_ADDRESS=')
                ${pkgs.libnotify}/bin/notify-send -u critical "$SERVICE FAILED!" "Run journalctl -xeu $SERVICE for details"
              '';
          };
        }
        // flip mapAttrs' config.services.btrbk.instances (
          name: _value:
            nameValuePair "btrbk-${name}" {
              unitConfig.OnFailure = "notify-problems@%i.service";
              preStart =
                mkBefore
                # sh
                ''
                  # waiting for internet after resume-from-suspend
                  until ${pkgs.iputils.out}/bin/ping google.com -c1 -q >/dev/null; do :; done
                '';
            }
        );
      # backup after boot in case laptop was powered off during scheduled event
      # for example, if you scheduled backups daily, your laptop should be powered on at 00:00
      timers = flip mapAttrs' config.services.btrbk.instances (
        name: _value:
          nameValuePair "btrbk-${name}" {
            timerConfig.Persistent = mkForce true;
          }
      );
    };

    # add the ssh directory to persist
    custom.persist = {
      root.directories = mkIf cfg.remote.enable [
        "/var/lib/btrbk"
      ];
    };
  };
}
