{
  lib,
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

  options.custom = with lib; {
    rmpc.enable = mkEnableOption "rmpc" // {
      default = true;
    };
  };

  config = lib.mkIf config.custom.rmpc.enable {
    home.packages = with pkgs; [
      rmpc
      playerctl
    ];

    services= {
      mpd = {
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
      # mpd to mpris2 bridge
      mpdris2 = {
        enable = true;
        # enable song change notifications
        notifications = true;
      };
      playerctld = {
        enable = true;
        package = pkgs.playerctl;
      };
    };

    programs.niri.settings.window-rules = [
      {
        matches = [
          {
            # mod+r launch rmpc with app-id 'rmpc'
            app-id = "^(rmpc)$";
          }
        ];
        default-column-width = {
          proportion = 0.35;
        };
        default-window-height = {
          proportion = 0.3;
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
  };
}
