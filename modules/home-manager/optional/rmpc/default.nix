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
            action.spawn = ["${pkgs.foot}/bin/foot" "--app-id=rmpc" "rmpc"];
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

    systemd.user.tmpfiles.settings = {
      # create ytDir if not existed
      "10-createYtDir".rules = {
        "%h/Music/YouTube" = {
          "d!" = {
            group = "users";
            inherit user;
          };
        };
      };
      # symlink from yt-dlp cache directory
      "10-symlinkYtDir".rules = {
        "%C/rmpc/youtube" = {
          "L+" = {
            argument = "%h/Music/YouTube";
          };
        };
      };
    };
  };
}
