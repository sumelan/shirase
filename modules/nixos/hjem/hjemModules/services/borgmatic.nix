{lib, ...}: let
  inherit (lib) mkOption mkEnableOption mkIf;
  inherit (lib.types) str;
in {
  flake.custom.hjemModules.borgmatic = {
    config,
    pkgs,
    ...
  }: let
    serviceCfg = config.rum.services.borgmatic;
    programCfg = config.rum.programs.borgmatic;
  in {
    options.rum = {
      services.borgmatic = {
        enable = mkEnableOption "Borgmatic service";

        frequency = mkOption {
          type = str;
          default = "hourly";
          description = ''
            How often to run borgmatic when
            `services.borgmatic.enable = true`.
            This value is passed to the systemd timer configuration as
            the onCalendar option. See
            {manpage}`systemd.time(7)`
            for more information about the format.
          '';
        };
      };
    };

    config = mkIf serviceCfg.enable {
      systemd = {
        services.borgmatic = {
          description = "borgmatic backup";

          serviceConfig = {
            Type = "oneshot";

            # Lower CPU and I/O priority:
            Nice = 19;
            IOSchedulingClass = "best-effort";
            IOSchedulingPriority = 7;
            IOWeight = 100;

            Restart = "no";
            LogRateLimitIntervalSec = 0;

            # Delay start to prevent backups running during boot:
            ExecStartPre = "${pkgs.coreutils}/bin/sleep 3m";

            ExecStart = ''
              ${pkgs.systemd}/bin/systemd-inhibit \
                --who="borgmatic" \
                --what="sleep:shutdown" \
                --why="Prevent interrupting scheduled backup" \
                ${programCfg.package}/bin/borgmatic \
                  --stats \
                  --verbosity -1 \
                  --list \
                  --syslog-verbosity 1
            '';
          };
        };

        timers.borgmatic = {
          description = "Run borgmatic backup";
          wantedBy = ["timers.target"];

          timerConfig = {
            OnCalendar = serviceCfg.frequency;
            Persistent = true;
            RandomizedDelaySec = "10m";
          };
        };
      };
    };
  };
}
