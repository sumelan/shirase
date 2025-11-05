{
  config,
  user,
  ...
}: let
  socketDir = "/run/user/1000/mpd";
in {
  systemd.user.tmpfiles.settings = {
    # create mpd directory for local socket on boot
    "10-createMpdDirectory".rules = {
      "%t/mpd" = {
        "d!" = {
          group = "users";
          inherit user;
        };
      };
    };
  };

  services = {
    mpd = {
      enable = true;
      musicDirectory = config.xdg.userDirs.music;
      dataDir = "${config.xdg.dataHome}/mpd";
      dbFile = "${config.services.mpd.dataDir}/tag_cache";
      playlistDirectory = "${config.services.mpd.dataDir}/playlists";
      # connect local socket
      network.listenAddress = "${socketDir}/socket";
      extraConfig = ''
        audio_output {
          type  "pipewire"
          name  "PipeWire Sound Server"
        }
      '';
    };

    # mpd to mpris2 bridge
    mpdris2 = {
      enable = true;
      notifications = true; # enable song change notifications
    };

    mpd-discord-rpc = {
      enable = true;
      settings = {
        hosts = [config.services.mpd.network.listenAddress];
        format = {
          details = "$title";
          state = "On $album by $artist";
          timestamp = "both";
          large_image = "notes";
          small_image = "notes";
          large_text = "";
          small_text = "";
          display_type = "name";
        };
      };
    };
  };

  custom.persist = {
    home.directories = [
      ".local/share/mpd"
    ];
  };
}
