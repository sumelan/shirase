{lib, ...}: let
  inherit (lib) getExe;
in {
  flake.modules.nixos.default = {
    config,
    pkgs,
    user,
    ...
  }: let
    inherit (config.hm.xdg.userDirs) music;
    inherit (config.hm.xdg) dataHome;
    cfg = config.services.mpd;
  in {
    services.mpd = rec {
      enable = true;
      inherit user;
      group = "users";
      openFirewall = true;
      dataDir = "${dataHome}/mpd";
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
        bind_to_address = "/run/user/1000/mpd/socket";
      };
    };

    systemd = {
      services = {
        mpd.environment = {XDG_RUNTIME_DIR = "/run/user/1000";};
        mpdris2-rs = {
          description = "Music Player Daemon D-Bus Bridge";
          wants = ["mpd.service"];
          after = ["mpd.service"];
          wantedBy = ["dafault.target"];
          serviceConfig = {
            Type = "simple";
            BusName = "org.mpris.MediaPlayer2.mpd";
            User = user;
            Group = "users";
            Restart = "on-failure";
            ExecStart = "${getExe pkgs.mpdris2-rs} --host ${cfg.settings.bind_to_address}";
          };
        };
      };
      user.tmpfiles.rules = [
        # create mpd directory for local socket on boot
        "d! %t/mpd - ${user} users - -"
      ];
    };

    custom.fileSystem = {
      persist.home.directories = [
        ".local/share/mpd"
      ];
    };
  };
}
