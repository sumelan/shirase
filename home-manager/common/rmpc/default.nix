{
  config,
  pkgs,
  user,
  ...
}:
{
  imports = [
    ./config.nix
    ./theme.nix
  ];

  home.packages = with pkgs; [ rmpc ];

  services = {
    mpd = {
      enable = true;
      musicDirectory = "/home/${user}/Music";
      dataDir = "/home/${user}/.config/mpd";
      dbFile = "/home/${user}/.config/mpd/tag_cache";
      extraConfig = ''
        audio_output {
          type  "pipewire"
          name  "PipeWire Sound Server"
        }
        bind_to_address "/home/${user}/.config/mpd/mpd_socket"
      '';
    };
    # mpd to mpris2 bridge
    mpdris2 = {
      enable = true;
      # enable song change notifications
      notifications = true;
    };
  };

  programs.niri.settings = {
    binds = with config.lib.niri.actions; {
      "Mod+R" = {
        action = spawn "ghostty" "--font-family=Maple Mono NF Medium" "-e" "rmpc";
        hotkey-overlay.title = "Rusty Music Player Client";
      };
    };
  };

  custom.persist = {
    home = {
      directories = [
        ".config/mpd"
      ];
      cache.directories = [
        # yt-dlp cache
        ".cache/rmpc"
      ];
    };
  };
}
