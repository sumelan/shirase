{pkgs, ...}: let
  vicinae-dynamiccast =
    pkgs.writeShellScriptBin "dynamiccast-selecter"
    # sh
    ''
      window='  Window'
      monitor='󰍹  Monitor'
      clear='  Clear'

      vicinae_cmd () {
          vicinae dmenu --placeholder "Dynamic Cast"
      }

      run_vicinae () {
          echo -e "$window\n$monitor\n$clear" | vicinae_cmd
      }

      run_cmd () {
          if [[ $1 == '--window' ]]; then
              niri msg action set-dynamic-cast-window --id $(niri msg --json pick-window | jq .id)
              notify-send -u low "Dynamic Cast" "Window picked."

          elif [[ $1 == '--monitor' ]]; then
              niri msg action set-dynamic-cast-monitor
              notify-send -u low "Dynamic Cast" "Monitor picked."
          elif [[ $1 == '--clear' ]]; then
              niri msg action clear-dynamic-cast-target
              notify-send -u low "Dynamic Cast" "Clear target."
          else
              exit 0
          fi
      }

      chosen="$(run_vicinae)"
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
    vicinae-dynamiccast
  ];
}
