_: {
  flake.modules.homeManager.default = {
    config,
    user,
    ...
  }: let
    inherit (config.xdg.userDirs) music;
    inherit (config.xdg) dataHome;
    cfg = config.services.mpd;
  in {
    systemd.user.tmpfiles.rules = [
      # create mpd directory for local socket on boot
      "d! %t/mpd - ${user} users - -"
    ];

    services = {
      mpd = let
        runtimeDir = "/run/user/1000/mpd";
      in {
        enable = true;
        musicDirectory = music;
        dataDir = "${dataHome}/mpd";
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
