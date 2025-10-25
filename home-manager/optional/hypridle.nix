{
  lib,
  config,
  pkgs,
  isLaptop,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    getExe
    getExe'
    concatStringsSep
    ;
in {
  options.custom = {
    hypridle.enable = mkEnableOption "hypridle";
  };

  config = mkIf config.custom.hypridle.enable {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          ignore_dbus_inhibit = true;
          # exec hyprlock unless already running
          lock_cmd = "${getExe' pkgs.procps "pidof"} hyprlock || ${getExe pkgs.hyprlock}";
          # kill hyprlock
          unlock_cmd = "${getExe' pkgs.procps "pkill"} -SIGUSR1 hyprlock";
          # stop playing when lock-session
          before_sleep_cmd = concatStringsSep "; " [
            "loginctl lock-session"
            "${getExe pkgs.playerctl} pause"
          ];
          # to avoid having to press a key twice to run on the display.
          after_sleep_cmd = "${getExe config.programs.niri.package} msg action power-on-monitors";
        };

        listener = [
          {
            timeout = 60 * 5;
            on-timeout = "${getExe config.programs.niri.package} msg action open-overview";
            on-resume = "${getExe config.programs.niri.package} msg action close-overview";
          }
          {
            timeout = 60 * 8;
            # lock screen when timeout has passed.
            on-timeout = "loginctl lock-session";
          }
          (mkIf config.custom.backlight.enable {
            timeout = 60 * 10;
            # set monitor backlight to minimum, avoid 0 on OLED monitor.
            # save previous state in a temporary file
            on-timeout = "${getExe pkgs.brightnessctl} --save set 3%";
            # restore monitor light
            on-resume = "${getExe pkgs.brightnessctl} -r";
          })
          {
            timeout = 60 * 15;
            # screen off when timeout has passed.
            on-timeout = "${getExe config.programs.niri.package} msg action power-off-monitors";
            # screen on when activity is detected after timeout has fired.
            on-resume = "${getExe config.programs.niri.package} msg action power-on-monitors";
          }
          (mkIf isLaptop {
            timeout = 60 * 20;
            # suspend pc.
            on-timeout = "${getExe' pkgs.systemd "systemctl"} suspend";
          })
        ];
      };
    };
  };
}
