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
      dbFile = "/home/${user}/.config/mpd/cache";
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
        action =
          spawn "${config.custom.terminal.exec}" "-T" "󱘗 Rusty Music Player Client" "-o"
            "font_family=Maple Mono NF"
            "-o"
            "font_size=12"
            "--app-id"
            "rmpc"
            "rmpc";
        hotkey-overlay.title = "Rusty Music Player Client";
      };
    };
    window-rules = [
      {
        matches = [ { app-id = "^(rmpc)$"; } ];
        default-column-width.proportion = 0.38;
        default-window-height.proportion = 0.38;
        open-floating = true;
        default-floating-position = {
          x = 8;
          y = 8;
          relative-to = "bottom-right";
        };
      }
    ];
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
