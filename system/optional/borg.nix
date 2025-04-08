{
  lib,
  config,
  user,
  host,
  ...
}:
# https://wiki.nixos.org/wiki/Borg_backup
let
  # exclude files inside /persist/home/sumelan
  common-excludes = [
    ".cache"
    "Downloads"
  ];
  projects-dirs = [
    "/persist/home/${user}/projects/wolborg"
  ];

  basicBorgJob = remote: {
    encryption.mode = "none";
    environment.BORG_RSH = "ssh -o 'StrictHostKeyChecking=no' -i /home/${user}/.ssh/${remote}";
    environment.BORG_UNKNOWN_UNENCRYPTED_REPO_ACCESS_IS_OK = "yes";
    extraCreateArgs = "--verbose --stats --checkpoint-interval 600";
    repo = "ssh://${remote}//media/${host}-backups";
    compression = "zstd,1";
    startAt = "daily";
    user = "${user}";
  };

  borgbackupMonitor =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    with lib;
    {
      key = "borgbackupMonitor";
      _file = "borgbackupMonitor";
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
        // flip mapAttrs' config.services.borgbackup.jobs (
          name: value:
          nameValuePair "borgbackup-job-${name}" {
            unitConfig.OnFailure = "notify-problems@%i.service";
            preStart = lib.mkBefore ''
              # waiting for internet after resume-from-suspend
              until ${pkgs.iputils.out}/bin/ping google.com -c1 -q >/dev/null; do :; done
            '';
          }
        );

      # optional, but this actually forces backup after boot in case laptop was powered off during scheduled event
      # for example, if you scheduled backups daily, your laptop should be powered on at 00:00
      config.systemd.timers = flip mapAttrs' config.services.borgbackup.jobs (
        name: value:
        nameValuePair "borgbackup-job-${name}" {
          timerConfig.Persistent = lib.mkForce true;
        }
      );
    };
in
{
  imports = [ borgbackupMonitor ];

  options.custom.borg = with lib; {
    enable = mkEnableOption "BorgBackup";
  };

  config = lib.mkIf config.custom.borg.enable {
    services.borgbackup.jobs = {
      "${host}-persist" = basicBorgJob "sakura" // rec {
        paths = "/persist/home/${user}";
        exclude = projects-dirs ++ map (x: paths + "/" + x) common-excludes;
      };
    };
  };
}
