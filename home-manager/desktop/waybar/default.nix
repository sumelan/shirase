{
  lib,
  config,
  ...
}:
let
  cfg = config.custom.waybar;
in
{
  imports = [
    ./style.nix
  ];

  options.custom = with lib; {
    waybar = {
      enable = mkEnableOption "waybar" // {
        default = true;
      };
      hwmon-path = mkOption {
        type = types.str;
        default = "/sys/class/thermal/thermal_zone3/temp";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      systemd.enable = true;

      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          spacing = 0;
          reload_style_on_change = true;

          modules-left = [
            "custom/actions"
            "niri/workspaces"
            "niri/window"
          ];

          modules-center = [
            "clock"
            "mpris"
          ];

          modules-right = [
            "custom/screencast"
            "privacy"
            "backlight"
            "wireplumber"
            "group/power"
            "group/hardware"
            "tray"
          ];

          "custom/actions" = {
            format = "";
            tooltip-format = "System Actions";
            on-click = "fuzzel-actions";
          };

          "niri/workspaces" = {
            format = "{icon}";
            format-icons = {
              "active" = "";
              "default" = "";
            };
          };

          "niri/window" = {
            max-length = 50;
            format = "{title}";
            icon = true;
          };

          clock = {
            format = "  {:%H:%M}";
            tooltip-format = "  {:%B %d, %A}";
            # tooltip-format="<tt><small>{calendar}</small></tt>";

            calendar = {
              mode = "month";
              weeks-pos = "left";
              mode-mon-col = 3;
              format = with config.lib.stylix.colors.withHashtag; {
                months = "<span color='${base06}'><b>{}</b></span>";
                days = "<span color='${base05}'><b>{}</b></span>";
                weeks = "<span color='${base0E}'><b>W{}</b></span>";
                weekdays = "<span color='${base0A}'><b>{}</b></span>";
                today = "<span color='${base0B}'><b><u>{}</u></b></span>";
              };
            };
          };

          mpris = {
            player = "mpd";
            format = "{player_icon} {status_icon} <b>{title}</b> by <i>{artist}</i>";
            tooltip-format = "Album: {album}";
            artist-len = 12;
            title-len = 22;
            ellipsis = "...";
            player-icons = {
              default = "";
              spotify = "󰓇";
              kdeconnect = "";
            };
            status-icons = {
              paused = "󰏤";
            };
            on-scroll-up = "playerctl volume 0.1+";
            on-scroll-down = "playerctl volume 0.1-";
          };

          "custom/screencast" = {
            exec = "screencast -w";
            return-type = "json";
            hide-empty-text = true;
            on-click = "screencast";
            interval = "once";
            signal = 1;
          };

          backlight = {
            format = "{icon}  {percent}%";
            format-icons = [
              "󱩎 "
              "󱩏 "
              "󱩐 "
              "󱩑 "
              "󱩒 "
              "󱩓 "
              "󱩔 "
              "󱩕 "
              "󱩖 "
              "󰛨 "
            ];
            tooltip = false;
          };

          wireplumber = {
            format = "{icon}  {volume}%";
            format-muted = "󰝟";
            on-click = "pwvucontrol";
            format-icons = [
              "󰕿"
              "󰖀"
              "󰕾"
            ];
          };

          "group/power" = {
            orientation = "inherit";

            drawer = {
              transition-duration = 300;
              transition-left-to-right = false;
            };

            modules = [
              "battery"
              "idle_inhibitor"
              "power-profiles-daemon"
            ];
          };

          battery = {
            states = {
              warning = 30;
              critical = 20;
            };
            format = "{icon}  {capacity}%";
            format-charging = "󱐋  {capacity}%";
            format-plugged = "  {capacity}%";
            format-alt = "{icon}  {time}";
            format-icons = [
              " "
              " "
              " "
              " "
              " "
            ];
          };

          idle_inhibitor = {
            format = "{icon}";

            format-icons = {
              activated = " ";
              deactivated = " ";
            };
          };

          power-profiles-daemon = {
            format = "{icon}";
            tooltip-format = "Power profile: {profile}\nDriver: {driver}";
            tooltip = true;
            format-icons = {
              default = "";
              performance = "";
              balanced = "";
              power-saver = "";
            };
          };

          "group/hardware" = {
            orientation = "inherit";

            drawer = {
              transition-duration = 300;
              transition-left-to-right = false;
            };

            modules = [
              "custom/btop"
              "disk"
              "cpu"
              "temperature"
              "memory"
            ];
          };

          "custom/btop" = {
            format = "";
            tooltip = false;
            on-click = "kitty --app-id btop btop";
          };

          disk = {
            format = "󰋊 PERSIST {percentage_used}%";
            path = "/persist";
          };

          cpu = {
            format = "  {usage}%";
            interval = 1;
          };

          temperature = {
            format = "  {temperatureC}°C";
            hwmon-path = cfg.hwmon-path;
            interval = 1;
            critical-format = "󰸁 {temperatureC}°C";
            critical-threshold = 90;
          };

          memory = {
            format = "  {used}/{total}GiB";
            interval = 1;
          };

          tray = {
            spacing = 5;
          };
        };
      };
    };

    stylix.targets = {
      waybar.enable = false;
    };
  };
}

