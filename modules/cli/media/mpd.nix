_: {
  flake.modules.homeManager.default = {
    config,
    user,
    ...
  }: {
    systemd.user.tmpfiles.rules = [
      # create mpd directory for local socket on boot
      "d! %t/mpd - ${user} users - -"
    ];

    services = let
      cfg = config.services.mpd;
      runtimeDir = "/run/user/1000/mpd";
    in {
      mpd = {
        enable = true;
        musicDirectory = config.xdg.userDirs.music;
        dataDir = "${config.xdg.dataHome}/mpd";
        dbFile = "${cfg.dataDir}/database";
        playlistDirectory = "${cfg.dataDir}/playlists";
        # connect local socket
        network.listenAddress = "${runtimeDir}/socket";
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
        # enable song change notifications
        notifications = true;
      };

      mpd-discord-rpc = {
        enable = true;
        settings = {
          hosts = [cfg.network.listenAddress];
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
    custom.persist.home.directories = [
      ".local/share/mpd"
    ];
  };
}
