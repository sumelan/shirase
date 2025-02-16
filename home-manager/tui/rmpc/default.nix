{ pkgs, user, ... }:
{
  imports = [
    ./config.nix
    ./theme.nix
  ];

  home.packages = with pkgs; [ rmpc ];

  services.mpd = {
    enable = true;
    musicDirectory = "/home/${user}/Music";
    dataDir = "/home/${user}/.config/mpd";
    dbFile = "/home/${user}/.config/mpd/tag_cache";
    extraConfig = ''
      audio_output {
        type            "pipewire"
        name            "PipeWire Sound Server"
      }
      bind_to_address	"/home/${user}/.config/mpd/mpd_socket"
    '';
  };

  xdg.configFile."rmpc/notify" = {
    source = ./notify.fish;
    executable = true;
  };

  programs.niri.settings.window-rules = [
    {
      matches = [
        {
          app-id = "^(com.mitchellh.ghostty)$";
        }
      ];
      default-column-width = {
        proportion = 0.3;
      };
      default-window-height = {
        proportion = 0.35;
      };
      open-floating = true;
      default-floating-position = {
        x = 10;
        y = 10;
        relative-to = "bottom-right";
      };
    }
  ];

  custom.persist = {
    home.directories = [
      ".config/mpd"
      # yt-dlp cache
      ".cache/rmpc"
    ];
  };
}
