{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.custom = with lib; {
    hyprlock.enable = mkEnableOption "hyprlock" // {
      default = true;
    };
  };

  config = lib.mkIf config.custom.hyprlock.enable {
    xdg.configFile."hypr/lock.png".source = ../../../../hosts/lock.png;

    programs = {
      hyprlock = {
        enable = true;
        settings = with config.lib.stylix.colors; {
          general = {
            hide_cursor = true;
            grace = 0;
          };
          background = {
            monitor = config.lib.monitors.mainMonitorName;
            path = "${config.xdg.configHome}/hypr/lock.png";
            color = "rgb(${base00})"; # fallback
            blur_size = 1; # blur size (distance)
            blur_passes = 2; # the amount of passes to perform. '0' disables blurring
          };
          input-field = {
            size = "300, 50";
            outline_thickness = 3;
            dots_size = 0.25;
            dots_spacing = 0.15;
            dots_center = true;
            dots_rounding = -1;
            fade_on_empty = false;
            fade_timeout = 1000;
            placeholder_text = "<span foreground='##${base05}'>󰌾  Logged in as <span foreground='##${base0D}'><i>$USER</i></span></span>";
            outer_color = "rgb(${base03})";
            inner_color = "rgb(${base00})";
            font_color = "rgb(${base05})";
            fail_color = "rgb(${base08})";
            check_color = "rgb(${base0A})";
            hide_input = false;
            rounding = -1;
            fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
            fail_transition = 300;
            capslock_color = "rgb(${base0A})";
            position = "0, -100";
            halign = "center";
            valign = "center";
          };
          image = {
            path = "${config.home.homeDirectory}/.anime-logo.png";
            size = 280;
            border_color = "rgb(${base0D})";
            position = "0, 100";
            halign = "center";
            valign = "center";
          };
          label =
            let
              dateCmd = pkgs.writers.writeFish "show_date_info" ''
                echo "$(date +'%B %d, %A')"
              '';

              mediaCmd = pkgs.writers.writeFish "show_media_info" ''
                set MAXINFO 28

                if test (playerctl -p spotify status) = Playing
                    set artist (playerctl -p spotify metadata xesam:artist)
                    set title (playerctl -p spotify metadata xesam:title)
                    set info " $artist - $title"
                    if test (string length $info) -gt $MAXINFO
                        set short (string shorten -m $MAXINFO $info)
                        echo "$short"
                    else
                        echo "$info"
                    end
                else if test (playerctl -p spotify status) = Paused
                    echo " - Paused -"
                end
              '';

              batteryCmd = pkgs.writers.writeFish "show_battery_info" ''
                set battery (cat /sys/class/power_supply/BAT*/capacity)
                set battery_status (cat /sys/class/power_supply/BAT*/status)

                set charging_icons 󰢜 󰂆 󰂇 󰂈 󰢝 󰂉 󰢞 󰂊 󰂋 󰂅
                set discharging_icons 󰁺 󰁻 󰁼 󰁽 󰁾 󰁿 󰂀 󰂁 󰂂 󰁹

                set icon (math round\($battery/10\))

                if test $battery_status = Full
                    echo "$charging_icons[10] Battery full"
                else if test $battery_status = Discharging
                    echo "$discharging_icons[$icon] Discharging $battery%"
                else if test $battery_status = "Not charging"
                    echo "$charging_icons[$icon] Battery charged"
                else
                    echo "$charging_icons[$icon] Charging $battery%"
                end
              '';

            in
            [
              {
                text = "$TIME";
                color = "rgb(${base05})";
                font_size = config.stylix.fonts.sizes.desktop * 9;
                font_family = "${config.stylix.fonts.monospace.name}";
                position = "-30, 0";
                halign = "right";
                valign = "top";
              }
              {
                text = "cmd[update:43200000] ${dateCmd}";
                color = "rgb(${base05})";
                font_size = config.stylix.fonts.sizes.desktop * 4;
                font_family = "${config.stylix.fonts.monospace.name}";
                position = "-30, -180";
                halign = "right";
                valign = "top";
              }
              {
                text = "cmd[update:1000] ${mediaCmd}";
                color = "rgb(${base05})";
                font_size = config.stylix.fonts.sizes.desktop * 2;
                font_family = "${config.stylix.fonts.monospace.name}";
                position = "-30, -300";
                halign = "right";
                valign = "top";
              }
              (lib.mkIf config.custom.battery.enable {
                text = "cmd[update:1000] ${batteryCmd}";
                color = "rgb(${base05})";
                font_size = config.stylix.fonts.sizes.desktop * 2;
                font_family = "${config.stylix.fonts.monospace.name}";
                position = "-30, -360";
                halign = "right";
                valign = "top";
              })
            ];
        };
      };
      niri.settings.binds =
        with config.lib.niri.actions;
        let
          ush = program: spawn "sh" "-c" "uwsm app -- ${program}";
        in
        {
          "Mod+Q" = {
            action = ush "hyprlock";
            hotkey-overlay.title = "Screenlock";
            allow-when-locked = true; # usefull when screen-locker crashed
          };
        };
    };
    stylix.targets.hyprlock.enable = false;
  };
}
