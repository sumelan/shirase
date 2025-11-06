{pkgs, ...}: let
  rofi-clipboard =
    pkgs.writeShellScriptBin "clipboard-history"
    # sh
    ''
      themeDir="$HOME/.config/rofi/themes"

      rofi_cmd () {
          rofi -dmenu -p "Clipboard History" -mesg "Select to paste" -theme "$themeDir/cliphist.rasi"
      }

      cliphist list | rofi_cmd | cliphist decode | wl-copy

    '';

  rofi-power =
    pkgs.writeShellScriptBin "power-selecter"
    # sh
    ''
      themeDir="$HOME/.config/rofi/themes"

      host=$(hostname)

      performance='󰓅 Performance'
      balanced='󰗑 Balanced'
      powersaver='󰌪 Power-Saver'

      rofi_cmd () {
          rofi -dmenu -p "$host" -mesg "Select profiles" -theme "$themeDir/selecter.rasi"
      }

      run_rofi () {
          echo -e "$performance\n$balanced\n$powersaver" | rofi_cmd
      }

      run_cmd () {
          if [[ $1 == '--performance' ]]; then
              powerprofilesctl set performance
              notify-send "Power-profile-daemon" "Switch to Performance mode"
          elif [[ $1 == '--balanced' ]]; then
              powerprofilesctl set balanced
              notify-send "Power-profile-daemon" "Switch to Balanced mode"
          elif [[ $1 == '--power-saver' ]]; then
              powerprofilesctl set power-saver
              notify-send "Power-profile-daemon" "Switch to Power-saver mode"
          else
              exit 0
          fi
      }

      chosen="$(run_rofi)"
      case "$chosen" in
          "$performance")
              run_cmd --performance
              ;;
          "$balanced")
              run_cmd --balanced
              ;;
          "$powersaver")
              run_cmd --power-saver
              ;;
      esac
    '';

  rofi-dynamiccast =
    pkgs.writeShellScriptBin "dynamiccast-selecter"
    # sh
    ''
      themeDir="$HOME/.config/rofi/themes"

      host=$(hostname)

      window=' Window'
      monitor='󰍹 Monitor'
      clear=' Clear'

      rofi_cmd () {
          rofi -dmenu -p "$host" -mesg "Select cast target" -theme "$themeDir/selecter.rasi"
      }

      run_rofi () {
          echo -e "$window\n$monitor\n$clear" | rofi_cmd
      }

      run_cmd () {
          if [[ $1 == '--window' ]]; then
              niri msg action set-dynamic-cast-window --id $(niri msg --json pick-window | jq .id)
          elif [[ $1 == '--monitor' ]]; then
              niri msg action set-dynamic-cast-monitor
          elif [[ $1 == '--clear' ]]; then
              niri msg action clear-dynamic-cast-target
          else
              exit 0
          fi
      }

      chosen="$(run_rofi)"
      case "$chosen" in
          "$window")
              run_cmd --window
              ;;
          "$monitor")
              run_cmd --monitor
              ;;
          "$clear")
              run_cmd --clear
              ;;
      esac
    '';
in {
  home.packages = [
    rofi-clipboard
    rofi-power
    rofi-dynamiccast
  ];
}
