{
  lib,
  config,
  pkgs,
  user,
  ...
}: let
  ytDir = "${config.xdg.userDirs.music}/YouTube";
in {
  imports = [
    ./config.nix
    ./theme.nix
  ];

  options.custom = {
    rmpc.enable =
      lib.mkEnableOption "A beautiful and configurable TUI client for MPD";
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
          "Mod+R" = lib.custom.niri.openTerminal {
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

    systemd.user.tmpfiles.rules =
      # create ytDir if not existed
      lib.custom.tmpfiles.mkCreateAndCleanup ytDir {
        inherit user;
        group = "users";
      }
      # symlink from yt-dlp cache directory
      ++ lib.custom.tmpfiles.mkSymlinks {
        dest = ytDir;
        src = "${config.xdg.cacheHome}/rmpc/youtube";
      };

    custom.persist.home = {
      directories = [
        ".config/mpd"
      ];
      cache.directories = [
        ".cache/rmpc"
      ];
    };
  };
}
