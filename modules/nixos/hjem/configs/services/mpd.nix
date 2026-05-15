_: {
  flake.custom.hjemConfigs.mpd = {
    config,
    user,
    ...
  }: let
    cfg = config.hj.rum.services.mpd;

    data = cfg.dataDir;
    host = cfg.settings.bind_to_address;
  in {
    hj.rum = {
      services = {
        mpd = {
          enable = true;
        };

        mpdris2-rs = {
          enable = true;
          inherit host;
        };

        mpd-discord-rpc = {
          enable = true;
          settings = {
            id = 677226551607033903;
            hosts = [host];

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
    };

    # create mpd directory if not existed on boot
    systemd.user.tmpfiles.rules = [
      "d! %t/mpd - ${user} users - -"
      "d! ${data}/playlists - ${user} users - -"
    ];

    custom.fileSystem = {
      persist.home.directories = [
        ".local/share/mpd"
      ];
    };
  };
}
