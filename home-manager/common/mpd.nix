{config, ...}: {
  services = {
    mpd = {
      enable = true;
      musicDirectory = config.xdg.userDirs.music;
      dataDir = "${config.xdg.configHome}/mpd";
      dbFile = "${config.xdg.configHome}/mpd/cache";
      extraConfig = ''
        audio_output {
          type  "pipewire"
          name  "PipeWire Sound Server"
        }
        bind_to_address "/run/mpd/socket"
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
        hosts = ["/run/mpd/socket"];
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
      ".config/mpd"
    ];
  };
}
