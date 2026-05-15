{
  config,
  lib,
  ...
}: let
  inherit (config) flake;
in {
  flake.modules.nixos.mpd = {
    config,
    pkgs,
    user,
    ...
  }: {
    imports = builtins.attrValues {
      inherit (flake.modules.nixos) mpdris2-rs discord-rpc;
    };

    options.custom = {
      services.mpd = {
        startWhenNeeded = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = ''
            If set, {command}`mpd` is socket-activated; that is, instead of having it permanently running as a daemon,
            systemd will start it on the first incoming connection.
          '';
        };

        settings = {
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
        };
      };
    };

    config = let
      cfg = config.custom.services.mpd;
      profileDir = "/etc/profiles/per-user/${user}";

      music = "${config.hj.directory}/Music";
      data = config.hj.xdg.data.directory;

      mpdConf = import ./_config.nix {inherit cfg pkgs music data;};
    in {
      # create mpd directory on boot
      systemd.user.tmpfiles.rules = [
        "d! %t/mpd - ${user} users - -"
        "d! ${data}/mpd/playlists - ${user} users - -"
      ];

      hj = {
        packages = [pkgs.mpd];

        systemd = {
          services.mpd =
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

      custom.fileSystem = {
        persist.home.directories = [
          ".local/share/mpd"
        ];
      };
    };
  };
}
