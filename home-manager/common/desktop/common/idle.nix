{
  lib,
  config,
  pkgs,
  isLaptop,
  ...
}:
{
  options.custom = {
    hypridle.enable = lib.mkEnableOption "Enable hypridle" // {
      default = true;
    };
  };

  config = lib.mkIf config.custom.hypridle.enable {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          ignore_dbus_inhibit = true;
          # exec hyprlock unless already running
          lock_cmd = "${lib.getExe' pkgs.procps "pidof"} hyprlock || ${lib.getExe pkgs.hyprlock}";
          # kill hyprlock
          unlock_cmd = " ${lib.getExe' pkgs.procps "pkill"} -SIGUSR1 hyprlock";
          # stop playing when lock-session
          before_sleep_cmd = lib.concatStringsSep "; " [
            "loginctl lock-session"
            "${lib.getExe pkgs.playerctl} pause"
          ];
          # to avoid having to press a key twice to run on the display.
          after_sleep_cmd = "niri msg action power-on-monitors";
        };

        listener = [
          {
            timeout = 60 * 8;
            on-timeout = "${lib.getExe' config.programs.dimland.package "dimland"} -a 0.5";
            on-resume = "${lib.getExe' config.programs.dimland.package "dimland"} stop";
          }
          {
            timeout = 60 * 10;
            # lock screen when timeout has passed.
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 60 * 15;
            # screen off when timeout has passed.
            on-timeout = "niri msg action power-off-monitors";
            # screen on when activity is detected after timeout has fired.
            on-resume = "niri msg action power-on-monitors";
          }
          (lib.optionalAttrs isLaptop {
            timeout = 60 * 30;
            on-timeout = "systemctl suspend"; # suspend pc.
          })
        ];
      };
    };
    systemd.user.services.hypridle = {
      Unit.After = lib.mkForce "graphical-session.target";
    };
  };
}
