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
      startWhenNeeded = true;
      settings = {
        audio_output = [
          {
            type = "pipewire";
            name = "PipeWire Sound Server";
          }
        ];
        music_directory = music;
        db_file = "${dataDir}/database";
        playlist_directory = "${dataDir}/playlists";
        bind_to_address = "/run/mpd/socket";
      };
    };

    systemd = {
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
      };
      tmpfiles.rules = [
        # create mpd directory for local socket on boot
        "d! %t/mpd - root root - -"
      ];
    };

    custom.fileSystem = {
      persist.home.directories = [
        ".local/share/mpd"
      ];
    };
  };
}
