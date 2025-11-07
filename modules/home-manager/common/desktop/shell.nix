{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) getExe;

  # Volume control script with audio feedback
  volumeScript =
    pkgs.writeShellScriptBin "volume-control"
    # sh
    ''
      case "$1" in
          up)
              ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
              ;;
          down)
              ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
              ;;
          mute)
              ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
              ;;
          *)
              echo "Usage: $0 up|down|mute"
              exit 1
              ;;
      esac

      ${pkgs.pipewire}/bin/pw-play ${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/audio-volume-change.oga
    '';

  # Brightness control script
  brightnessScript =
    pkgs.writeShellScriptBin "brightness-control"
    # sh
    ''
      case "$1" in
          up)
              ${pkgs.brightnessctl}/bin/brightnessctl set 5%+
              ;;
          down)
              ${pkgs.brightnessctl}/bin/brightnessctl set 5%-
              ;;
          *)
              echo "Usage: $0 up|down"
              exit 1
              ;;
      esac
      ${pkgs.pipewire}/bin/pw-play ${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/audio-volume-change.oga
    '';

  # Media control script
  mediaScript =
    pkgs.writeShellScriptBin "media-control"
    #sh
    ''
      case "$1" in
          play-pause)
              ${pkgs.playerctl}/bin/playerctl play-pause
              ;;
          next)
              ${pkgs.playerctl}/bin/playerctl next
              ;;
          previous)
              ${pkgs.playerctl}/bin/playerctl previous
              ;;
          stop)
              ${pkgs.playerctl}/bin/playerctl pause
              ;;
          *)
              echo "Usage: $0 play-pause|next|previous|stop"
              exit 1
              ;;
      esac
    '';

  # Display control script
  displayScript =
    pkgs.writeShellScriptBin "display-control"
    #sh
    ''
      case "$1" in
          power-off-monitors)
              ${getExe config.programs.niri.package} msg action power-off-monitors
              ;;
          power-on-monitors)
              ${getExe config.programs.niri.package} msg action power-on-monitors
              ;;
          *)
              echo "Usage: $0 power-off-monitors|power-on-monitors"
              exit 1
              ;;
      esac
    '';

  # Session control script
  sessionScript =
    pkgs.writeShellScriptBin "session-control"
    #sh
    ''
      case "$1" in
          lock)
              ${pkgs.gtklock}/bin/gtklock
              ;;
          logout)
              ${getExe config.programs.niri.package} msg action quit
              ;;
          suspend)
              ${pkgs.systemd}/bin/systemctl suspend
              ;;
          hibernate)
              ${pkgs.systemd}/bin/systemctl hibernate
              ;;
          reboot)
              ${pkgs.systemd}/bin/systemctl reboot
              ;;
          poweroff)
              ${pkgs.systemd}/bin/systemctl poweroff
              ;;
          *)
              echo "Usage: $0 lock|logout|suspend|hibernate|reboot|poweroff"
              exit 1
              ;;
      esac
    '';

  batteryScript =
    pkgs.writeScriptBin "battery-notify"
    # sh
    ''
      notify_levels=(3 5 10 20)
      BAT=$(ls /sys/class/power_supply |grep BAT |head -n 1)
      last_notify=100

      while true; do
          bat_lvl=$(cat /sys/class/power_supply/''${BAT}/capacity)
          if [ $bat_lvl -gt $last_notify ]; then
                  last_notify=$bat_lvl
          fi
          for notify_level in ''${notify_levels[@]}; do
              if [ $bat_lvl -le $notify_level ]; then
                  if [ $notify_level -lt $last_notify ]; then
                      notify-send -u critical "Low Battery" "$bat_lvl% battery remaining."
                      last_notify=$bat_lvl
                  fi
              fi
          done
      sleep 60
      done
    '';
in {
  home.packages = [
    volumeScript
    brightnessScript
    mediaScript
    displayScript
    sessionScript
    batteryScript
  ];
}
