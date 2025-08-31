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
    programs = {
      rmpc.enable = true;
      niri.settings = {
        binds = {
          "Mod+R" = lib.custom.niri.openTerminal {
            app = pkgs.rmpc;
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

    custom.persist = {
      home.cache.directories = [
        ".cache/rmpc"
      ];
    };
  };
}
