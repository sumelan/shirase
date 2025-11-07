{pkgs, ...}: let
  soundPath = "${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo";

  # Volume control script with audio feedback
  volumeScript =
    pkgs.writeShellScriptBin "volume-control"
    # sh
    ''
      case "$1" in
          up)
              wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
              ;;
          down)
              wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
              ;;
          mute)
              wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
              ;;
          *)
              echo "Usage: $0 up|down|mute"
              exit 1
              ;;
      esac

      pw-play ${soundPath}/audio-volume-change.oga
    '';

  # Brightness control script
  brightnessScript =
    pkgs.writeShellScriptBin "brightness-control"
    # sh
    ''
      case "$1" in
          up)
              brightnessctl set 5%+
              ;;
          down)
              brightnessctl set 5%-
              ;;
          *)
              echo "Usage: $0 up|down"
              exit 1
              ;;
      esac
      pw-play ${soundPath}/audio-volume-change.oga
    '';

  # Media control script
  mediaScript =
    pkgs.writeShellScriptBin "media-control"
    #sh
    ''
      case "$1" in
          play-pause)
              playerctl play-pause
              ;;
          next)
              playerctl next
              ;;
          previous)
              playerctl previous
              ;;
          stop)
              playerctl pause
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
              niri msg action power-off-monitors
              ;;
          power-on-monitors)
              niri msg action power-on-monitors
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
              gtklock -d
              ;;
          logout)
              pw-play ${soundPath}/service-logout.oga
              niri msg action quit --skip-confirmation
              ;;
          suspend)
              systemctl suspend
              ;;
          hibernate)
              systemctl hibernate
              ;;
          reboot)
              systemctl reboot
              ;;
          poweroff)
              systemctl poweroff
              ;;
          *)
              echo "Usage: $0 lock|logout|suspend|hibernate|reboot|poweroff"
              exit 1
              ;;
      esac
    '';

  dunstSoundScript =
    pkgs.writeShellScriptBin "dunst-sound"
    # sh
    ''
      if [[ "$DUNST_APP_NAME" != "Spotify" ]] && [[ "$DUNST_APP_NAME" != "Music Player Daemon" ]]; then
          if [[ "$DUNST_URGENCY" = "LOW" ]]; then
              pw-play ${soundPath}/message.oga
          elif [[ "$DUNST_URGENCY" = "NORMAL" ]]; then
              pw-play ${soundPath}/message-new-instant.oga
          else
              pw-play ${soundPath}/dialog-warning.oga
          fi
      fi
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
    dunstSoundScript
    batteryScript
  ];
}
