{
  inputs,
  lib,
  pkgs,
  user,
  isLaptop,
  isDesktop,
  ...
}: let
  inherit (lib) optionalString getExe';
  stasisPkg = inputs.stasis.packages.${pkgs.stdenv.hostPlatform.system}.stasis;
in {
  users.users.${user}.extraGroups = ["input"];

  hm = {
    home.packages = [stasisPkg];

    xdg.configFile = let
      lidBehavior =
        optionalString isLaptop
        # rune
        ''
          lid_close_action "lock-screen"  # lock-screen | suspend | custom | ignore
            lid_open_action "wake"          # wake | custom | ignore
        '';

      desktopActions =
        optionalString isDesktop
        # rune
        ''
          # Desktop-only actions
            custom-niri-overview:
              timeout ${builtins.toString (60 * 5)}
              command "niri msg action open-overview"
              resume-command "niri msg action close-overview"
            end

            custom-dimland:
              timeout ${builtins.toString (60 * 10)}
              command "dimland -a 0.6"
              resume-command "dimland stop"
            end

            lock_screen:
              timeout ${builtins.toString (60 * 15)}
              command "loginctl lock-session"
              resume-command "pkill -SIGUSR1 gtklock"
              lock-command "gtklock -d"
            end

            dpms:
              timeout ${builtins.toString (60 * 20)}
              command "niri msg action power-off-monitors"
              resume-command "niri msg action power-on-monitors"
            end
        '';

      laptopActions =
        optionalString isLaptop
        # rune
        ''
          # Laptop-only AC actions
            on_ac:
              custom-niri-overview:
                timeout ${builtins.toString (60 * 5)}
                command "niri msg action open-overview"
                resume-command "niri msg action close-overview"
              end

              custom-dimland:
                timeout ${builtins.toString (60 * 8)}
                command "dimland -a 0.4"
                resume-command "dimland stop"
              end

              lock_screen:
                timeout ${builtins.toString (60 * 10)}
                command "loginctl lock-session"
                resume-command "pkill -SIGUSR1 gtklock"
                lock-command "gtklock -d"
              end

              dpms:
                timeout ${builtins.toString (60 * 12)}
                command "niri msg action power-off-monitors"
                resume-command "niri msg action power-on-monitors"
              end

              suspend:
                timeout ${builtins.toString (60 * 20)}
                command "systemctl suspend"
                resume-command None
              end
            end

            # Laptop-only battery actions
            on_battery:
              custom-niri-overview:
                timeout ${builtins.toString (60 * 3)}
                command "niri msg action open-overview"
                resume-command "niri msg action close-overview"
              end

              custom-dimland:
                timeout ${builtins.toString (60 * 5)}
                command "dimland -a 0.6"
                resume-command "dimland stop"
              end

              lock_screen:
                timeout ${builtins.toString (60 * 8)}
                command "loginctl lock-session"
                resume-command "pkill -SIGUSR1 gtklock"
                lock-command "gtklock -d"
              end

              dpms:
                timeout ${builtins.toString (60 * 10)}
                command "niri msg action power-off-monitors"
                resume-command "niri msg action power-on-monitors"
              end

              suspend:
                timeout ${builtins.toString (60 * 15)}
                command "systemctl suspend"
                resume-command None
              end
            end
        '';
    in {
      "stasis/stasis.rune".text =
        # rune
        ''
          @author "${user}"
          @description "Stasis configuration file"

          # Global variable
          default_timeout ${builtins.toString (60 * 10)}

          stasis:
            pre_suspend_command "gtklock -d"
            monitor_media true
            ignore_remote_media true

            # Optional: ignore specific media players
            media_blacklist ["spotify" "mpd"]

            respect_idle_inhibitors true

            ${lidBehavior}

            # Debounce: default is 3s; can be customized if needed
            #debounce_seconds 4

            # Applications that prevent idle when active
            inhibit_apps [
              "vlc"
              "Spotify"
              "mpv"
              r".*\.exe"
              r"steam_app_.*"
              r"librewolf.*"
              r"helium.*"
            ]

            ${desktopActions}
            ${laptopActions}
          end
        '';
    };

    systemd.user.services."stasis" = {
      Unit = {
        Description = "Stasis Wayland Idle Manager";
        After = ["graphical-session.target"];
        Wants = ["graphical-session.target"];
      };
      Service = {
        Type = "simple";
        ExecStart = getExe' stasisPkg "stasis";
        Restart = "always";
        RestartSec = 5;
        Environment = ["WAYLAND_DISPLAY=wayland-1"];
        # Optional: wait until WAYLAND_DISPLAY exists
        ExecStartPre = ''
          ${pkgs.bash}/bin/sh -c "while [ ! -e /run/user/%U/wayland-1 ]; do sleep 0.1; done"
        '';
      };
      Install = {
        WantedBy = ["default.target"];
      };
    };
  };
}
