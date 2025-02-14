{
  pkgs,
  lib,
  config,
  user,
  isLaptop,
  ...
}:
{
  imports = [
    ./style.nix
  ];

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
          "privacy"
          "backlight"
          "wireplumber"
          "group/power"
          "group/hardware"
          "tray"
          "custom/fnott"
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
          player = "spotify";
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
          on-click = "kitty btop";
        };

        disk = {
          format = "󰋊 HOME {percentage_used}%";
          path = "/persist/home/${user}";
        };

        cpu = {
          format = "  {usage}%";
          interval = 1;
        };

        temperature = {
          format = "  {temperatureC}°C";
          hwmon-path = lib.mkIf (!isLaptop) "/sys/class/hwmon/hwmon2/temp1_input";
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

        "custom/fnott" = {
          return-type = "json";
          exec = "fnott-dnd -w";
          exec-if = "which fnott-dnd";
          interval = "once";
          signal = 2;

          on-click = "fnottctl dismiss";
          on-click-right = "fnott-dnd";
        };
      };
    };
  };

  systemd.user.services.waybar.Unit.After = lib.mkForce "graphical-session.target";

  home.activation.restartWaybar = lib.hm.dag.entryAfter ["installPackages"] ''
    if ${lib.getExe' pkgs.procps "pgrep"} waybar > /dev/null; then
      ${lib.getExe' pkgs.procps "pkill"} -SIGUSR2 waybar
    fi '';

  home.file.".config/waybar/scripts" = {
    source = ./scripts;
    executable = true;
  };
}

