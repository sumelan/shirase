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
    getExe
    singleton
    ;
  inherit (lib.custom.tmpfiles) mkCreateAndCleanup mkSymlinks;
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
            action.spawn = ["${getExe pkgs.foot}" "--app-id=rmpc" "rmpc"];
            hotkey-overlay.title = ''<span foreground="#EFD49F">[  rmpc]</span> TUI MPD Client'';
          };
        };
        window-rules = [
          {
            matches = singleton {
              app-id = "^(rmpc)$";
            };
            open-floating = true;
            default-column-width.proportion = 0.35;
            default-window-height.proportion = 0.28;
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
  };
}
