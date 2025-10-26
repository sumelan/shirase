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
          lock_cmd = "${pkgs.procps}/bin/pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
          # kill hyprlock
          unlock_cmd = "${pkgs.procps}/bin/pkill -SIGUSR1 hyprlock";
          # stop playing when lock-session
          before_sleep_cmd = concatStringsSep "; " [
            "${pkgs.systemd}/bin/loginctl lock-session"
            "${pkgs.playerctl}/bin/playerctl pause"
          ];
          # to avoid having to press a key twice to run on the display.
          after_sleep_cmd = "${pkgs.niri}/bin/niri msg action power-on-monitors";
        };

        listener = [
          {
            timeout = 60 * 5;
            on-timeout = "${pkgs.niri}/bin/niri msg action open-overview";
            on-resume = "${pkgs.niri}/bin/niri msg action close-overview";
          }
          (mkIf config.custom.backlight.enable {
            timeout = 60 * 8;
            # set monitor backlight to minimum, avoid 0 on OLED monitor.
            # save previous state in a temporary file
            on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl --save set 3%";
            # restore monitor light
            on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -r";
          })
          {
            timeout = 60 * 15;
            # lock screen when timeout has passed.
            on-timeout = "${pkgs.systemd}/bin/loginctl lock-session";
          }
          {
            timeout = 60 * 18;
            # screen off when timeout has passed.
            on-timeout = "${pkgs.niri}/bin/niri msg action power-off-monitors";
            # screen on when activity is detected after timeout has fired.
            on-resume = "${pkgs.niri}/bin/niri msg action power-on-monitors";
          }
          (mkIf isLaptop {
            timeout = 60 * 20;
            # suspend pc.
            on-timeout = "${pkgs.systemd}/bin/systemctl suspend";
          })
        ];
      };
    };
  };
}
