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

        startWhenNeeded = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = ''
            If set, {command}`mpd` is socket-activated; that is, instead of having it permanently running as a daemon,
            systemd will start it on the first incoming connection.
          '';
        };

        dataDir = lib.mkOption {
          type = lib.types.path;
          default = "${config.xdg.data.directory}/mpd";
          description = ''
            The directory where MPD stores its state, tag cache, playlists etc.
          '';
        };

        settings = {
          music_directory = lib.mkOption {
            type = lib.types.path;
            default = "${config.directory}/Music";
            description = ''
              The directory or URI where MPD reads music from.
            '';
          };

          playlist_directory = lib.mkOption {
            type = lib.types.path;
            default = "${cfg.dataDir}/playlists";
            description = ''
              The directory where MPD stores playlists.
            '';
          };

          bind_to_address = lib.mkOption {
            type = lib.types.str;
            default = "/run/user/1000/mpd/socket"; # local socket
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
            default = "${cfg.dataDir}/data_base";
            description = ''
              The path to MPD's database.
            '';
          };
        };
      };
    };

    config = lib.mkIf cfg.enable {
      # install mpd units
      packages = [pkgs.mpd];

      systemd = {
        services.mpd = let
          profileDir = "/etc/profiles/per-user/${config.user}";
          data = cfg.dataDir;
          music = cfg.settings.music_directory;
          playlists = cfg.settings.playlist_directory;
          db = cfg.settings.db_file;

          mpdConf = import ./_mpdConf.nix {inherit cfg pkgs data music playlists db;};
        in
          {
            description = "Music Player Daemon";
            after =
              [
                "network.target"
                "sound.target"
              ]
              ++ lib.optionals cfg.startWhenNeeded ["mpd.socket"];
            wantedBy = lib.mkIf cfg.startWhenNeeded ["default.target"];

            serviceConfig = {
              Environment = ["PATH=${profileDir}/bin"];
              ExecStart = "${lib.getExe pkgs.mpd} --no-daemon ${mpdConf}";
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
