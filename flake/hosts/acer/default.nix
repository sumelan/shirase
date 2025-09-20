{
  lib,
  config,
  pkgs,
  inputs,
  user,
  ...
}: let
  inherit
    (lib)
    mkIf
    genAttrs
    mapAttrs'
    flip
    nameValuePair
    mkBefore
    mkForce
    ;
in {
  imports = with inputs.nixos-hardware.nixosModules; [
    common-pc-laptop
    common-pc-laptop-ssd
    common-cpu-intel
  ];

  # btrbk client settings
  # set remote instances and systemd service that will notify when backup fails
  # plus, add the ssh directory to persist
  services.btrbk.instances = mkIf config.custom.btrbk.enable {
    "remote-backup" = let
      retentionPolicy = {
        stream_compress = "lz4";
        snapshot_create = "onchange";
        snapshot_preserve_min = "7d";
        snapshot_preserve = "7d 4w";
        target_preserve_min = "no";
        target_preserve = "7d 4w";
      };
    in {
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
            target = "ssh://sakura/media/4TWD/acer-backups";
          };
        };
    };
  };

  systemd.services =
    mkIf config.custom.btrbk.enable
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
  systemd.timers = mkIf config.custom.btrbk.enable (flip mapAttrs' config.services.btrbk.instances (
    name: _value:
      nameValuePair "btrbk-${name}" {
        timerConfig.Persistent = mkForce true;
      }
  ));

  custom = let
    enableList = [
    ];
    disableList = [
      "distrobox"
    ];
  in
    {
      stylix.colorTheme = "nord";
    }
    // genAttrs enableList (_name: {
      enable = true;
    })
    // genAttrs disableList (_name: {
      enable = false;
    });
}
