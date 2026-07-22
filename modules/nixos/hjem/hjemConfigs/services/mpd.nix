{lib, ...}: {
  flake.custom.hjemConfigs.mpd = {
    config,
    user,
    ...
  }: let
    cfg = config.hjem.users.${user}.rum.services.mpd;
    data = cfg.dataDir;
  in {
    hjem.users.${user}.rum = {
      services = {
        mpd = {
          enable = lib.mkDefault false;
          startWhenNeeded = true;
          settings.bind_to_address = lib.mkDefault "/run/user/1000/mpd/socket"; # local socket
        };

        mpdris2-rs = {
          enable = lib.mkDefault false;
          host = cfg.settings.bind_to_address;
        };

        mpd-discord-rpc = {
          enable = lib.mkDefault false;
          settings = {
            id = 677226551607033903;
            hosts = [cfg.settings.bind_to_address];
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
    # systemd.user.tmpfiles.rules = [
    #   "d! %t/mpd - ${user} users - -"
    #   "d! ${data}/playlists - ${user} users - -"
    # ];

    # custom.fileSystem = {
    #   persist.home.directories = [
    #     ".local/share/mpd"
    #   ];
    # };
  };
}
