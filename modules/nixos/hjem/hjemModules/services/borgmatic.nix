{lib, ...}: let
  inherit
    (lib)
    mkOption
    mkEnableOption
    mkIf
    mkPackageOption
    literalExpression
    mapAttrs'
    nameValuePair
    getExe
    getExe'
    ;

  inherit (lib.types) str;
in {
  flake.custom.hjemModules.borgmatic = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.rum.services.borgmatic;

    yamlFmt = pkgs.formats.yaml {};
  in {
    options.rum = {
      services.borgmatic = {
        enable = mkEnableOption "Borgmatic";
        package = mkPackageOption pkgs "borgmatic" {};
        systemd = {
          enable = mkEnableOption "Borgmatic service";
          frequency = mkOption {
            type = str;
            default = "daily";
            description = ''
              How often to run borgmatic when `services.borgmatic.enable = true`.
              This value is passed to the systemd timer configuration as the onCalendar option.
              See {manpage}`systemd.time(7)` for more information about the format.
            '';
          };
        };

        configurations = mkOption {
          inherit (yamlFmt) type;
          description = ''
            Set of borgmatic configurations, see <https://torsion.org/borgmatic/docs/reference/configuration/>
            Borgmatic allows for several named backup configurations, each with its own source directories and repositories.
          '';
          example = literalExpression ''
            {
              personal = {
                source_directories = [ "/home/me/personal" ];
                repositories = [ "ssh://myuser@myserver.com/./personal-repo" ];
              };
              work = {
                source_directories = [ "/home/me/work" ];
                repositories = [ "ssh://myuser@myserver.com/./work-repo" ];
              };
            };
          '';
        };
      };
    };

    config = let
      configFiles =
        mapAttrs' (
          name: value:
            nameValuePair "borgmatic.d/${name}.yaml" {
              source = yamlFmt.generate "${name}.yaml" value;
            }
        )
        cfg.configurations;
    in
      mkIf cfg.enable {
        packages = [cfg.package];

        xdg.config.files = configFiles;

        systemd = mkIf cfg.systemd.enable {
          services.borgmatic = {
            description = "borgmatic backup";
            documentation = ["https://torsion.org/borgmatic/"];
            wants = ["network-online.target"];
            after = ["network-online.target"];

            serviceConfig = {
              Type = "oneshot";

              # Lower CPU and I/O priority:
              Nice = 19;
              IOSchedulingClass = "best-effort";
              IOSchedulingPriority = 7;
              IOWeight = 100;

              Restart = "no";

              # Prevent rate limiting of borgmatic log events.
              LogRateLimitIntervalSec = 0;

              # Delay start to prevent backups running during boot:
              ExecStartPre = "${getExe' pkgs.coreutils "sleep"} 3m";

              ExecStart = ''
                ${getExe' pkgs.systemd "systemd-inhibit"} \
                  --who="borgmatic" \
                  --what="sleep:shutdown" \
                  --why="Prevent interrupting scheduled backup" \
                  ${getExe cfg.package} \
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
              OnCalendar = cfg.systemd.frequency;
              Persistent = true;
              RandomizedDelaySec = "10m";
            };
          };
        };
      };
  };
}
