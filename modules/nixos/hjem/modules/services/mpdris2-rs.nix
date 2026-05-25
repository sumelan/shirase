{lib, ...}: {
  flake.custom.hjemModules.mpdris2-rs = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.rum.services.mpdris2-rs;
  in {
    options.rum = {
      services.mpdris2-rs = {
        enable = lib.mkEnableOption "mpdris2-rs, A lightweight implementation of MPD to D-Bus bridge";

        host = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = ''
            hostname + port, or UNIX socket path of MPD server, similar to what `mpc` takes
            - if not configured, `MPD_HOST` will be used
            - if `MPD_HOST` is not set either, `localhost:6600` is the default
            - UNIX socket path has to be absolute
            - Abstract sockets are supported on Linux (socket path that starts with `@`, e.g., `@mpd_socket`)
          '';
        };

        notifications = {
          enable = lib.mkEnableOption "song change notifications";

          timeout = lib.mkOption {
            type = lib.types.float;
            default = 5.0;
            description = "notification timeout (default 5 secs)";
          };

          summary = lib.mkOption {
            type = lib.types.str;
            default = "%artist% - %album%";
            description = ''
              Templating for the notification summary.
              See <https://github.com/szclsya/mpdris2-rs?tab=readme-ov-file#configuration> for available variables.
            '';
          };

          summaryPaused = lib.mkOption {
            type = lib.types.str;
            default = "%artist% - %album%";
            description = ''
              Templating for the notification summary (when paused).
              See <https://github.com/szclsya/mpdris2-rs?tab=readme-ov-file#configuration> for available variables.
            '';
          };

          body = lib.mkOption {
            type = lib.types.str;
            default = "%title% (%elapsed%/%duration%)";
            description = ''
              Templating for the notification body.
              See <https://github.com/szclsya/mpdris2-rs?tab=readme-ov-file#configuration> for available variables.
            '';
          };

          bodyPaused = lib.mkOption {
            type = lib.types.str;
            default = "%title% (%elapsed%/%duration%)";
            description = ''
              Templating for the notification body (when paused).
              See <https://github.com/szclsya/mpdris2-rs?tab=readme-ov-file#configuration> for available variables.
            '';
          };
        };
      };
    };

    config = lib.mkIf cfg.enable {
      systemd.services = {
        mpdris2-rs = {
          description = "Music Player Daemon D-Bus Bridge";
          wants = ["mpd.service"];
          after = ["mpd.service"];
          wantedBy = ["default.target"];

          serviceConfig = {
            Type = "dbus";
            BusName = "org.mpris.MediaPlayer2.mpd";
            Restart = "on-failure";
            ExecStart = let
              args = lib.concatStringsSep " " ([
                  "--host ${cfg.host}"
                ]
                ++ lib.optionals (!cfg.notifications.enable) ["--no-notification"]
                ++ lib.optionals cfg.notifications.enable [
                  "--notification-timeout ${cfg.notifications.timeout}"
                  "--notification-summary ${cfg.notificatiopns.summary}"
                  "--notification-summary-paused ${cfg.notifications.summaryPaused}"
                  "--notification-body ${cfg.notifications.body}"
                  "--notification-body-paused ${cfg.notifications.bodyPaused}"
                ]);
            in "${lib.getExe pkgs.mpdris2-rs} ${args}";
          };
        };
      };
    };
  };
}
