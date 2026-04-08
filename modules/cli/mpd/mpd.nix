{lib, ...}: let
  inherit (lib) getExe getExe';
in {
  flake.modules.nixos.default = {
    config,
    pkgs,
    user,
    ...
  }: let
    music = "${config.hj.directory}/Music";
    data = config.hj.xdg.data.directory;
    cfg = config.services.mpd;
  in {
    services.mpd = rec {
      enable = true;
      inherit user;
      group = "users";
      openFirewall = true;
      dataDir = "${data}/mpd";
      startWhenNeeded = false;
      settings = {
        audio_output = [
          {
            type = "pipewire";
            name = "PipeWire Sound Server";
          }
          {
            type = "fifo";
            name = "FIFO";
            path = "/run/mpd/mpd.fifo";
            format = "44100:16:2";
          }
        ];
        music_directory = music;
        db_file = "${dataDir}/database";
        playlist_directory = "${dataDir}/playlists";
        bind_to_address = "/run/mpd/socket";
      };
    };

    systemd = {
      # create mpd directory on boot
      tmpfiles.rules = [
        "d! %t/mpd - root root - -"
      ];

      services = {
        mpd.environment = {XDG_RUNTIME_DIR = "/run/user/1000";};

        mpdris2-rs = {
          description = "Music Player Daemon D-Bus Bridge";
          wants = ["mpd.service"];
          after = ["mpd.service"];
          wantedBy = ["default.target"];

          serviceConfig = {
            Type = "simple";
            BusName = "org.mpris.MediaPlayer2.mpd";
            User = user;
            Group = "users";
            Restart = "on-failure";
            ExecStartPre = getExe' pkgs.coreutils "sleep 5s";
            ExecStart = "${getExe pkgs.mpdris2-rs} --host ${cfg.settings.bind_to_address}";
          };
        };

        mpd-discord-rpc = {
          description = "Discord Rich Presence for MPD";
          documentation = ["https://github.com/JakeStanger/mpd-discord-rpc"];
          environment = {XDG_RUNTIME_DIR = "/run/user/1000";};
          after = ["graphical-session.target"] ++ ["mpd.service"];
          partOf = ["graphical-session.target"];
          wantedBy = ["graphical-session.target"] ++ ["mpd.service"];

          serviceConfig = {
            User = user;
            Group = "users";
            ExecStart = getExe pkgs.mpd-discord-rpc;
            Restart = "on-failure";
          };
        };
      };
    };

    hj.xdg.config.files."discord-rpc/config.toml" = {
      generator = (pkgs.formats.toml {}).generate "config.toml";
      value = import ./discord-rpc/_config.nix {inherit config;};
    };

    custom.fileSystem = {
      persist.home.directories = [
        ".local/share/mpd"
      ];
    };
  };
}
