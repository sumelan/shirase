{
  lib,
  config,
  pkgs,
  user,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    flip
    mapAttrs'
    nameValuePair
    ;
in {
  options.custom = {
    syncoid.enable = mkEnableOption "syncoid";
  };

  config = mkIf config.custom.syncoid.enable {
    # allow syncoid to ssh into HDDs
    users.users = {
      "syncoid" = {
        # services.syncoid automaticall set user "syncoid" as systemuser
        openssh.authorizedKeys.keyFiles = [
          ../../hosts/acer/id_ed25519.pub
        ];
      };
    };

    # sync zfs to HDDs on desktop
    services.syncoid = {
      enable = true;

      # 23:50 daily
      interval = "*-*-* 23:50:00";
    };

    # notify when syncoid fails
    systemd.services =
      {
        "notify-problems@" = {
          enable = true;
          serviceConfig.User = user;
          environment.SERVICE = "%i";
          script = ''
            export $(cat /proc/$(${pkgs.procps}/bin/pgrep "gnome-session" -u "$USER")/environ |grep -z '^DBUS_SESSION_BUS_ADDRESS=')
            ${pkgs.libnotify}/bin/notify-send -u critical "$SERVICE FAILED!" "Run journalctl -u $SERVICE for details"
          '';
        };
      }
      // flip mapAttrs' config.services.syncoid.commands (
        name: _value:
          nameValuePair "syncoid-${name}" {
            unitConfig.OnFailure = "notify-problems@%i.service";
            # waiting for internet after resume-from-suspend
            preStart = lib.mkBefore ''
              until /run/wrappers/bin/ping google.com -c1 -q >/dev/null; do :; done
            '';
          }
      );

    # persist syncoid .ssh
    # For syncoid to be able to create /var/lib/syncoid/.ssh/ and to use custom ssh_config or known_hosts.
    custom.persist = {
      root.directories = ["/var/lib/syncoid"];
    };
  };
}
