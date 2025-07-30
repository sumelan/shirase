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

  options.custom = {
    rmpc.enable = lib.mkEnableOption "A beautiful and configurable TUI client for MPD" // {
      default = true;
    };
  };

  config = lib.mkIf config.custom.rmpc.enable {
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
          bind_to_address "${config.xdg.configHome}/mpd/mpd_socket"
        '';
      };
      # mpd to mpris2 bridge
      mpdris2 = {
        enable = true;
        notifications = true; # enable song change notifications
      };
    };

    programs = {
      rmpc.enable = true;

      niri.settings = {
        binds = {
          "Mod+M" = lib.custom.niri.openTerminal {
            app = pkgs.rmpc;
            terminal = config.profiles.${user}.defaultTerminal.package;
          };
        };
        window-rules = [
          {
            matches = lib.singleton {
              app-id = "^(rmpc)$";
            };
            open-floating = true;
            default-column-width.proportion = 0.50;
            default-window-height.proportion = 0.40;
          }
        ];
      };
    };

    custom = {
      symlinks = {
        # make a symlink to yt-dlp cache directory
        "${config.xdg.userDirs.music}/YouTube" = "${config.xdg.cacheHome}/rmpc/youtube";
      };

      persist.home = {
        directories = [
          ".config/mpd"
        ];
        cache.directories = [
          ".cache/rmpc"
        ];
      };
    };
  };
}
