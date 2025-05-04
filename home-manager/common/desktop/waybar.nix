{ config, pkgs, ... }:
let
  moduleConfiguration =
    # jsonc
    ''
      // Modules configuration
      "image": {
        "path": "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake-white.svg",
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
        "on-scroll-up": "light -A 1",
        "on-scroll-down": "light -U 1",
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
        "format-wifi": "<span size='13000' foreground='#${config.lib.stylix.colors.base06}'>󰖩  </span>{essid}",
        "format-ethernet": "<span size='13000' foreground='#${config.lib.stylix.colors.base06}'>󰤭</span> Disconnected",
        "format-linked": "{ifname} (No IP) 󱚵",
        "format-disconnected": "<span size='13000' foreground='#${config.lib.stylix.colors.base06}'> </span>Disconnected",
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
          "battery",
          "memory",
          "network",
          "wireplumber",
          "backlight"
        ]
      }
    '';
  trayBackgroundColor = if config.stylix.polarity == "dark" then "@base00" else "@base05";
  colors = {
    inherit (config.lib.stylix.colors.withHashtag)
      base00
      base01
      base04
      base05
      base06
      base07
      base08
      base09
      base0A
      base0B
      base0C
      base0D
      base0E
      base0F
      ;
  };
in
{
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = config.wayland.systemd.target;
    };
  };
  home.file = {
    ".config/waybar/config.jsonc".text =
      let
        otherMonitorsConfig =
          map (
            name:
            # json
            ''
              {
                "position": "top",
                "layer": "top",
                "output": "${name}",
                "modules-left": [
                  "niri/workspaces",
                  "niri/window"
                ],
                "modules-right": [
                  "tray",
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
          {
            "position": "top",
            "layer": "top",
            "output": "${config.lib.monitors.mainMonitorName}",
            "modules-left": [
              "image",
              "niri/workspaces",
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

    ".config/waybar/colors.css".text =
      # css
      (builtins.mapAttrs (name: value: "@define-color ${name} ${value};") colors)
      |> builtins.attrValues
      |> builtins.concatStringsSep "\n";

    ".config/waybar/tray.css".text =
      # css
      ''
        #tray {
          background: shade(alpha(${trayBackgroundColor}, 0.9), 1);
        }
      '';
    ".config/waybar/style.css".text =
      # css
      ''
        @import "animation.css";
        @import "colors.css";
        @import "tray.css";

        * {
          /* all: unset; */
          font-family: "Maple Mono NF";
          font-weight: bold;
          font-size: 18px;
          min-height: 0;
        }

        window#waybar {
          /* border-radius: 15px; */
          /* color: @base04; */
          background: transparent;
        }

        tooltip {
          background: @base01;
          border-radius: 5px;
          border-width: 2px;
          border-style: solid;
          border-color: @base07;
        }

        #image,
        #idle_inhibitor,
        #custom-screencast,
        #network,
        #clock,
        #battery,
        #wireplumber,
        #workspaces,
        #backlight,
        #memory,
        #tray,
        #window {
          padding: 4px 10px;
          background: shade(alpha(@base00, 0.9), 1);
          text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.377);
          color: @base05;
          margin-top: 10px;
          margin-bottom: 5px;
          margin-left: 5px;
          margin-right: 5px;
          box-shadow: 1px 2px 2px #101010;
          border-radius: 10px;
        }

        #custom-screencast {
          color: @base05;
          background: @base08;
          animation: blink 1s linear infinite alternate;
        }

        #idle_inhibitor.activated {
          color: @base00;
          background: shade(alpha(@base09, 0.9), 1);
        }

        #workspaces {
          margin-left: 15px;
          font-size: 0px;
          padding: 6px 3px;
          border-radius: 20px;
        }

        #workspaces button {
          font-size: 0px;
          background-color: @base07;
          padding: 0px 1px;
          margin: 0px 4px;
          border-radius: 20px;
          transition: all 0.25s cubic-bezier(0.55, -0.68, 0.48, 1.682);
        }

        #workspaces button.active {
          font-size: 1px;
          background-color: @base0E;
          border-radius: 20px;
          min-width: 30px;
          background-size: 400% 400%;
        }

        #workspaces button.empty {
          font-size: 1px;
          background-color: @base04;
        }

        #window {
          color: @base00;
          background: radial-gradient(circle, @base05 0%, @base07 100%);
          background-size: 400% 400%;
          animation: gradient_f 40s ease-in-out infinite;
          transition: all 0.3s cubic-bezier(0.55, -0.68, 0.48, 1.682);
        }

        window#waybar.empty #window {
          background: none;
          background-color: transparent;
          box-shadow: none;
        }

        #battery {
          margin-right: 15px;
          background: @base0F;
          /* background: linear-gradient(118deg, @base07 0%, @base0F 25%, @base07 50%, @base0F 75%, @base07 100%); */
          /* background: linear-gradient(118deg, @base07 5%, @base0F 5%, @base0F 20%, @base07 20%, @base07 40%, @base0F 40%, @base0F 60%, @base07 60%, @base07 80%, @base0F 80%, @base0F 95%, @base07 95%);  */
          background: linear-gradient(
            118deg,
            @base0E 5%,
            @base0D 5%,
            @base0D 20%,
            @base0E 20%,
            @base0E 40%,
            @base0D 40%,
            @base0D 60%,
            @base0E 60%,
            @base0E 80%,
            @base0D 80%,
            @base0D 95%,
            @base0E 95%
          );
          background-size: 200% 300%;
          animation: gradient_f_nh 6s linear infinite;
          color: @base01;
        }

        #battery.charging,
        #battery.plugged {
          background: linear-gradient(
            118deg,
            @base0B 5%,
            @base0C 5%,
            @base0C 20%,
            @base0B 20%,
            @base0B 40%,
            @base0C 40%,
            @base0C 60%,
            @base0B 60%,
            @base0B 80%,
            @base0C 80%,
            @base0C 95%,
            @base0B 95%
          );
          background-size: 200% 300%;
          animation: gradient_rv 4s linear infinite;
        }

        #battery.full {
          background: linear-gradient(
            118deg,
            @base0B 5%,
            @base0C 5%,
            @base0C 20%,
            @base0B 20%,
            @base0B 40%,
            @base0C 40%,
            @base0C 60%,
            @base0B 60%,
            @base0B 80%,
            @base0C 80%,
            @base0C 95%,
            @base0B 95%
          );
          background-size: 200% 300%;
          animation: gradient_rv 20s linear infinite;
        }

        #tray > .passive {
          -gtk-icon-effect: dim;
        }

        #tray > .needs-attention {
          -gtk-icon-effect: highlight;
        }
      '';

    ".config/waybar/animation.css".text =
      # css
      ''
        @keyframes blink {
          to {
            color: @base00;
            background: @base01;
          }
        }

        @keyframes gradient {
          0% {
            background-position: 0% 50%;
          }
          50% {
            background-position: 100% 30%;
          }
          100% {
            background-position: 0% 50%;
          }
        }

        @keyframes gradient_f {
          0% {
            background-position: 0% 200%;
          }
          50% {
            background-position: 200% 0%;
          }
          100% {
            background-position: 400% 200%;
          }
        }

        @keyframes gradient_f_nh {
          0% {
            background-position: 0% 200%;
          }
          100% {
            background-position: 200% 200%;
          }
        }

        @keyframes gradient_rv {
          0% {
            background-position: 200% 200%;
          }
          100% {
            background-position: 0% 200%;
          }
        }
      '';
  };
}
