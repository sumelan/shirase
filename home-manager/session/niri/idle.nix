{
  lib,
  config,
  ...
}:
{
  options.custom = with lib; {
    hypridle.enable = mkEnableOption "Enable hypridle" // {
      default = config.custom.niri.enable;
    };
  };

  config = lib.mkIf config.custom.hypridle.enable {
    services.hypridle = {
      enable = true;
      settings = {
        general = let
          beforeSleep = l: lib.concatStringsSep "; " l;
        in {
          ignore_dbus_inhibit = false;
          lock_cmd = "hyprlock";
          unlock_cmd = "pkill -SIGUSR1 hyprlock";
          before_sleep_cmd = beforeSleep [
            "loginctl lock-session"
            "playerctl pause"
          ];
          after_sleep_cmd = "niri msg action power-on-monitors"; # to avoid having to press a key twice to run on the display.
        };
        listener = [
          {
            timeout = 60*5;
            on-timeout = "brightnessctl -s set 10"; # set monitor backlight to minomum, avoid 0 on OLED monitor.
            on-resume = "brightnessctl -r"; # monitor backlight restor.
          }
          {
            timeout = 60*8;
            on-timeout = "loginctl lock-session"; # lock screen when timeout has passed.
          }
          {
            timeout = 60*10;
            on-timeout = "niri msg action power-off-monitors"; # screen off when timeout has passed.
            on-resume = "niri msg action power-on-monitors"; # screen on when activity is detected after timeout has fired.
          }
          {
            timeout = 60*15;
            on-timeout = "systemctl suspend"; # suspend pc.
          }
        ];
      };
    };
    systemd.user.services.hypridle.Unit.After = lib.mkForce "graphical-session.target";
  };
}

