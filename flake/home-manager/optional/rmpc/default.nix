{
  lib,
  config,
  pkgs,
  user,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    singleton
    ;
  inherit
    (pkgs.lib.tmpfiles)
    mkCreateAndCleanup
    mkSymlinks
    ;

  ytDir = "${config.xdg.userDirs.music}/YouTube";
in {
  imports = [
    ./config.nix
    ./theme.nix
  ];

  options.custom = {
    rmpc.enable =
      mkEnableOption "A beautiful and configurable TUI client for MPD";
  };

  config = mkIf config.custom.rmpc.enable {
    programs = {
      rmpc.enable = true;
      niri.settings = {
        binds = {
          "Mod+R" = {
            action.spawn = ["${lib.getExe pkgs.kitty}" "-o" "confirm_os_window_close=0" "--app-id=rmpc" "rmpc"];
            hotkey-overlay.title = ''<span foreground="${config.lib.stylix.colors.withHashtag.base0B}">[Terminal]</span> rmpc'';
          };
        };
        window-rules = [
          {
            matches = singleton {
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
      mkCreateAndCleanup ytDir {
        inherit user;
        group = "users";
      }
      # symlink from yt-dlp cache directory
      ++ mkSymlinks {
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
