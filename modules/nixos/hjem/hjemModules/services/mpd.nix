{lib, ...}: {
  flake.custom.hjemModules.mpd = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.rum.services.mpd;
  in {
    options.rum = {
      services.mpd = {
        enable = lib.mkEnableOption "Music Player Daemon";

        package = lib.mkPackageOption pkgs "mpd" {};

        enableSessionVariables = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = ''
            Whether to set {env}`MPD_HOST` {env}`MPD_PORT` environment variables
            according to {option}`services.mpd.network`.
          '';
        };

        startWhenNeeded = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            If set, {command}`mpd` is socket-activated; that is, instead of having it permanently running as a daemon,
            systemd will start it on the first incoming connection.
          '';
        };

        dataDir = lib.mkOption {
          type = lib.types.path;
          default = "${config.xdg.data.directory}/mpd";
          apply = toString; # Prevent copies to Nix store.
          description = ''
            The directory where MPD stores its state, tag cache, playlists etc.
          '';
        };

        settings = {
          music_directory = lib.mkOption {
            type = lib.types.path;
            default = "${config.directory}/Music";
            apply = toString; # Prevent copies to Nix store.
            description = ''
              The directory or URI where MPD reads music from.
            '';
          };

          playlist_directory = lib.mkOption {
            type = lib.types.path;
            default = "${cfg.dataDir}/playlists";
            apply = toString; # Prevent copies to Nix store.
            description = ''
              The directory where MPD stores playlists.
            '';
          };

          bind_to_address = lib.mkOption {
            type = lib.types.str;
            default = "127.0.0.1";
            description = ''
              The address for the daemon to listen on.
              Use `any` to listen on all addresses.
            '';
          };

          port = lib.mkOption {
            type = lib.types.port;
            default = 6600;
            description = ''
              This setting is the TCP port that is desired for the daemon to get assigned to.
            '';
          };

          db_file = lib.mkOption {
            type = lib.types.path;
            default = "${cfg.dataDir}/database";
            description = ''
              The path to MPD's database.
            '';
          };
        };
      };
    };

    config = lib.mkIf cfg.enable {
      # install mpd units
      packages = [cfg.package];

      environment.sessionVariables = lib.mkIf cfg.enableSessionVariables ({
          MPD_PORT = toString cfg.settings.port;
        }
        // lib.optionalAttrs (cfg.settings.bind_to_address != "any") {
          MPD_HOST = cfg.settings.bind_to_address;
        });

      systemd = {
        services.mpd = let
          data = cfg.dataDir;
          music = cfg.settings.music_directory;
          playlists = cfg.settings.playlist_directory;
          db = cfg.settings.db_file;

          mpdConf = pkgs.writeText "mpd.conf" (''
              music_directory    "${music}"
              playlist_directory "${playlists}"
            ''
            + ''
              db_file            "${db}"
            ''
            + ''
              state_file         "${data}/state"
              sticker_file       "${data}/sticker.sql"
            ''
            + pkgs.lib.optionalString (cfg.settings.bind_to_address != "any") ''
              bind_to_address    "${cfg.settings.bind_to_address}"
            ''
            + pkgs.lib.optionalString (cfg.settings.port != 6600) ''
              port               "${toString cfg.settings.port}"
            ''
            + ''
              audio_output {
                name             "PipeWire Sound Server"
                type             "pipewire"
              }

              audio_output {
                format           "48000:16:2"
                name             "FIFO"
                path             "/run/user/1000/mpd/mpd.fifo"
                type             "fifo"
              }
            '');
        in
          {
            description = "Music Player Daemon";
            path = ["/etc/profiles/per-user/${config.user}"];
            after =
              [
                "network.target"
                "sound.target"
              ]
              ++ lib.optionals cfg.startWhenNeeded ["mpd.socket"];
            wantedBy = lib.mkIf cfg.startWhenNeeded ["default.target"];

            serviceConfig = {
              ExecStart = "${lib.getExe cfg.package} --no-daemon ${mpdConf}";
              RuntimeDirectory = "mpd";
            };
          }
          // (lib.optionalAttrs cfg.startWhenNeeded {
            requires = ["mpd.socket"];
          });

        sockets.mpd = {
          wantedBy = ["sockets.target"];

          listenStreams = [
            "" # Note: this is needed to override the upstream unit
            (
              if lib.hasPrefix "/" cfg.settings.bind_to_address
              then cfg.settings.bind_to_address
              else "${
                lib.optionalString (cfg.settings.bind_to_address != "any") "${cfg.settings.bind_to_address}:"
              }${toString cfg.settings.port}"
            )
          ];
        };
      };
    };
  };
}
