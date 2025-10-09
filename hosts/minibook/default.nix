{
  lib,
  config,
  pkgs,
  user,
  ...
}: let
  inherit
    (lib)
    flip
    mkMerge
    mkIf
    mkBefore
    mkForce
    mapAttrs'
    nameValuePair
    genAttrs
    ;
in
  mkMerge [
    {
      hardware = {
        chuwi-minibook-x = {
          tabletMode.enable = true;
          autoDisplayRotation = {
            enable = true;
            commands = {
              normal = ''niri msg output "DSI-1" transform normal'';
              bottomUp = ''niri msg output "DSI-1" transform 180'';
              rightUp = ''niri msg output "DSI-1" transform 270'';
              leftUp = ''niri msg output "DSI-1" transform 90'';
            };
          };
        };
        i2c.enable = true;
      };
    }
    {
      #  programs.ssh = {
      #   extraConfig = ''
      # Host sakura
      #   HostName 192.168.68.62
      #   Port 22
      #   User root
      # '';
      #};
    }
    (mkIf config.custom.btrbk.enable {
      # set remote instances and systemd service that will notify when backup fails
      # plus, add the ssh directory to persist
      services.btrbk.instances = let
        retentionPolicy = {
          stream_compress = "lz4";
          snapshot_create = "onchange";
          snapshot_preserve_min = "7d";
          snapshot_preserve = "7d 4w";
          target_preserve_min = "no";
          target_preserve = "7d 4w";
        };
      in {
        "remote-backup" = {
          onCalendar = "daily";
          settings =
            retentionPolicy
            // {
              ssh_user = "btrbk";
              # must be readable by user/group btrbk
              ssh_identity = "/var/lib/btrbk/.ssh/btrbk_key";

              volume."/" = {
                group = "remote";
                subvolume = {
                  "persist" = {
                    group = "remote-persist"; # for command line filtering
                    snapshot_dir = "/cache/snapshots";
                    snapshot_name = "persist";
                  };
                };
                target = "ssh://sakura/media/WD4T/minibook-remote";
              };
            };
        };
      };
      systemd.services =
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
              preStart = mkBefore ''
                # waiting for internet after resume-from-suspend
                until ${pkgs.iputils.out}/bin/ping google.com -c1 -q >/dev/null; do :; done
              '';
            }
        );
      # optional, but this actually forces backup after boot in case laptop was powered off during scheduled event
      # for example, if you scheduled backups daily, your laptop should be powered on at 00:00
      systemd.timers = flip mapAttrs' config.services.btrbk.instances (
        name: _value:
          nameValuePair "btrbk-${name}" {
            timerConfig.Persistent = mkForce true;
          }
      );

      custom.persist = {
        root.directories = [
          "/var/lib/btrbk"
        ];
      };
    })
    {
      custom = let
        enableList = [
          "alsa"
          "logitech"
        ];
        disableList = [
          "distrobox"
        ];
      in
        genAttrs enableList (_name: {
          enable = true;
        })
        // genAttrs disableList (_name: {
          enable = false;
        });
    }
  ]
