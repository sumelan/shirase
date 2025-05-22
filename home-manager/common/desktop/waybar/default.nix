{
  lib,
  config,
  pkgs,
  user,
  self,
  ...
}:
# NOTE: multiple waybar setting using HM is broken?
let
  moduleConfiguration =
    # jsonc
    ''
      // Modules configuration
      "image": {
        "path": "/home/${user}/.themed-logo.png",
        "size": 24,
        "tooltip": false,
        "on-click": "fuzzel-actions"
      },
      "niri/workspaces": {
        "format": "{icon}",
        "format-icons": {
          // "default": "󱄅 ",
          // "default": " ",
          // "active": " "
          "default": ""
        }
      },
      "custom/nix-updates": {
        "exec": "update-checker",
        "signal": 12,
        "on-click": "", // refresh on click
        "on-click-right": "rm ~/.cache/update-checker/nix-update-last-run", // force an update
        "interval": 3600, // refresh every hour
        "tooltip": true,
        "return-type": "json",
        "format": "{} {icon}",
        "format-icons": {
          "has-updates": "", // icon when updates needed
          "updated": "" // icon when all packages updated
        },
      },
      "niri/window": {
        "format": "{}",
        "separate-outputs": true,
        "icon": true,
        "icon-size": 18
      },
      "memory": {
        "interval": 30,
        "format": "<span foreground='#${config.lib.stylix.colors.base0E}'>  </span>  {used:0.1f}G/{total:0.1f}G",
        "on-click": "kitty --class=htop --title=htop -e htop"
      },
      "backlight": {
        "device": "intel_backlight",
        "on-scroll-up": "${lib.getExe' pkgs.light "light"} -A 1",
        "on-scroll-down": "${lib.getExe' pkgs.light "light"} -U 1",
        "format": "<span size='13000' foreground='#${config.lib.stylix.colors.base0D}'>{icon} </span>  {percent}%",
        "format-icons": [
          "",
          ""
        ],
        "tooltip": false
      },
      "tray": {
        "icon-size": 16,
        "spacing": 10
      },
      "clock": {
        "format": "<span foreground='#${config.lib.stylix.colors.base0E}'>  </span>  {:%a %d %H:%M}",
        "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>",
        "on-click": "kitty --class=tty-clock --title=tty-clock -e ${pkgs.tty-clock}/bin/tty-clock -s -c -C 5"
      },
      "battery": {
        "states": {
          "warning": 30,
          "critical": 15
        },
        "format": "<span size='13000' foreground='#${config.lib.stylix.colors.base0B}'>{icon}  </span>{capacity}%",
        "format-warning": "<span size='13000' foreground='#${config.lib.stylix.colors.base0B}'>{icon}  </span>{capacity}%",
        "format-critical": "<span size='13000' foreground='#${config.lib.stylix.colors.base08}'>{icon}  </span>{capacity}%",
        "format-charging": "<span size='13000' foreground='#${config.lib.stylix.colors.base0B}'>  </span>{capacity}%",
        "format-plugged": "<span size='13000' foreground='#${config.lib.stylix.colors.base0B}'>  </span>{capacity}%",
        "format-alt": "<span size='13000' foreground='#${config.lib.stylix.colors.base0B}'>{icon} </span>{time}",
        "format-full": "<span size='13000' foreground='#${config.lib.stylix.colors.base0B}'>  </span>{capacity}%",
        "format-icons": [
          "",
          "",
          "",
          "",
          ""
        ],
        "tooltip-format": "{time}",
        "interval": 5
      },
      "idle_inhibitor": {
        "format": "{icon}",
        "format-icons": {
          "activated": "",
          "deactivated": ""
        },
        "tooltip": true
      },
      "network": {
        "format-wifi": "<span size='13000' foreground='#${config.lib.stylix.colors.base0B}'>󰖩  </span>{essid}",
        "format-ethernet": "<span size='13000' foreground='#${config.lib.stylix.colors.base0B}'>󰈀</span> Connected",
        "format-linked": "{ifname} (No IP) 󱚵",
        "format-disconnected": "<span size='13000' foreground='#${config.lib.stylix.colors.base0B}'> </span>Disconnected",
        "tooltip-format-wifi": "Signal Strenght: {signalStrength}%"
      },
      "wireplumber": {
        "format": "<span size='13000' foreground='#${config.lib.stylix.colors.base0A}'>{icon}  </span>{volume}%",
        "format-muted": "<span size='13000' foreground='#${config.lib.stylix.colors.base0A}'>  </span>Muted",
        "on-click": "pwvucontrol",
        "format-icons": [
            "",
            "󰖀",
            ""
        ]
      },
      "custom/screencast": {
        "exec": "screencast -w",
        "return-type": "json",
        "hide-empty-text": true,
        "on-click": "screencast",
        "interval": "once",
        "signal": 1
      },
      "group/meters": {
        "orientation": "inherit",
        "drawer": {
          "transition-duration": 500,
          "transition-left-to-right": false
        },
        "modules": [
          "custom/monitor",
          "disk",
          "cpu",
          "temperature"
        ]
      },
      "custom/monitor": {
        "format": "",
        "tooltip": false
      },
      "disk": {
        "format": "󰋊 {percentage_used}%"
      },
      "cpu": {
        "format": "  {usage}%",
        "interval": 2
      },
      "temperature": {
        "format": "  {temperatureC}°C",
        "hwmon-path": "/sys/class/hwmon/hwmon2/temp1_input",
        "interval": 2,
        "critical-format": "󰸁 {temperatureC}°C",
        "critical-threshold": 90
      }
    '';
in
{
  imports = [
    ./style.nix
  ];

  home.packages = with pkgs; [ brightnessctl ] ++ [ self.packages.${pkgs.system}.update-checker ];

  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = config.wayland.systemd.target;
    };
  };

  xdg.configFile."waybar/config.jsonc".text =
    let
      otherMonitorsConfig =
        map (
          name:
          # json
          ''
            {
              "position": "top",
              "layer": "top",
              "reload_style_on_change": true,
              "output": "${name}",
              "modules-left": [
                "niri/workspaces",
                "niri/window"
              ],
              "modules-right": [
                "group/meters"
              ],
              ${moduleConfiguration}
            },
          '') config.lib.monitors.otherMonitorsNames
        |> builtins.concatStringsSep "\n";
    in
    # json
    ''
      [
        ${otherMonitorsConfig}
        {
          "position": "top",
          "layer": "top",
          "reload_style_on_change": true,
          "output": "${config.lib.monitors.mainMonitorName}",
          "modules-left": [
            "image",
            "niri/workspaces",
            "custom/nix-updates",
            "tray",
            "niri/window"
          ],
          "modules-center": [
            "clock",
            "memory"
          ],
          "modules-right": [
            "idle_inhibitor",
            "custom/screencast",
            "network",
            "wireplumber",
            "backlight",
            "battery"
          ],
          ${moduleConfiguration}
        }
      ]
    '';

  custom.persist = {
    home.cache.directories = [
      ".cache/update-checker"
    ];
  };
}
