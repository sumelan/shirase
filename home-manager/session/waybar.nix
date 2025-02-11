{ config, ...}: let
  moduleConfiguration =
    /*
    jsonc
    */
    ''
      // Modules configuration
      "niri/workspaces": {
        "format": "{icon}",
        "format-icons": {
          // "coding": " ",
          // "browsing": " ",
          // "reading": "󰈙",
          // "default": "󱄅 ",
          // "default": " ",
          // "active": " "
          "default": ""
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
        "on-click": "kitty --class=htop,htop -e htop"
      },
      "backlight": {
        "device": "intel_backlight",
        "on-scroll-up": "light -A 1",
        "on-scroll-down": "light -U 1",
        "format": "<span size='13000' foreground='#${config.lib.stylix.colors.base0D}'>{icon} </span>  {percent}%",
        "format-icons": [
          "",
          ""
        ]
      },
      "tray": {
        "icon-size": 16,
        "spacing": 10
      },
      "clock": {
        "format": "<span foreground='#${config.lib.stylix.colors.base0E}'>  </span>  {:%a %d %H:%M}",
        "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>",
        "on-click": "kitty --class=clock,clock --title=clock -o remember_window_size=no -o initial_window_width=600 -o initial_window_height=200 -e tty-clock -s -c -C 5"
      },
      "battery": {
        "states": {
          "warning": 30,
          "critical": 15,
        },
        "format": "<span size='13000' foreground='#${config.lib.stylix.colors.base0E}'>{icon}  </span>{capacity}%",
        "format-warning": "<span size='13000' foreground='#${config.lib.stylix.colors.base0E}'>{icon}  </span>{capacity}%",
        "format-critical": "<span size='13000' foreground='#${config.lib.stylix.colors.base08}'>{icon}  </span>{capacity}%",
        "format-charging": "<span size='13000' foreground='#${config.lib.stylix.colors.base0E}'>  </span>{capacity}%",
        "format-plugged": "<span size='13000' foreground='#${config.lib.stylix.colors.base0E}'>  </span>{capacity}%",
        "format-alt": "<span size='13000' foreground='#${config.lib.stylix.colors.base0E}'>{icon} </span>{time}",
        "format-full": "<span size='13000' foreground='#${config.lib.stylix.colors.base0E}'>  </span>{capacity}%",
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
      "network": {
        "format-wifi": "<span size='13000' foreground='#${config.lib.stylix.colors.base06}'>󰖩  </span>{essid}",
        "format-ethernet": "<span size='13000' foreground='#${config.lib.stylix.colors.base06}'>󰤭</span> Disconnected",
        "format-linked": "{ifname} (No IP) 󱚵",
        "format-disconnected": "<span size='13000' foreground='#${config.lib.stylix.colors.base06}'> </span>Disconnected",
        "tooltip-format-wifi": "Signal Strenght: {signalStrength}%",
        "on-click": "kitty --class nmtui,nmtui --title=nmtui -o remember_window_size=no -o initial_window_width=400 -o initial_window_height=400 -e doas nmtui"
      },
      "pulseaudio": {
        "on-click": "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle",
        "on-scroll-up": "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.01+",
        "on-scroll-down": "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.01-",
        "format": "<span size='13000' foreground='#${config.lib.stylix.colors.base0A}'>{icon}  </span>{volume}%",
        "format-muted": "<span size='13000' foreground='#${config.lib.stylix.colors.base0A}'>  </span>Muted",
        "format-icons": {
          "headphone": "󱡏",
          "hands-free": "",
          "headset": "󱡏",
          "phone": "",
          "portable": "",
          "car": "",
          "default": [
            "󰕿",
            "󰖀",
            "󰕾",
            "󰕾"
          ]
        }
      }
    '';
in {
  home.file = {
    ".config/niri/waybar/config.jsonc".text =
      /*
      jsonc
      */
      ''
        [
          {
            "position": "top",
            "layer": "top",
            "output": "eDP-1",
            "modules-left": [
              "niri/workspaces",
              "tray",
              "niri/window"
            ],
            "modules-center": [
              "clock",
              "memory"
            ],
            "modules-right": [
              "network",
              "pulseaudio",
              "backlight",
              "battery",
            ],
            ${moduleConfiguration}
          },
          {
            "position": "top",
            "layer": "top",
            "output": "HDMI-A-1",
            "modules-left": [
              "niri/window"
            ],
            "modules-right": [
              "niri/workspaces",
              "tray",
              "group/meters"
            ],
            ${moduleConfiguration}
          }
        ]
      '';
    ".config/niri/waybar/style.css".text =
      /*
      css
      */
      ''
        @import "animation.css";
        * {
            /* all: unset; */
            font-size: 14px;
            /* font-family: "Comic Mono Nerd Font"; */
          font-family: "Hug Me Tight";
          min-height: 0;
        }
        window#waybar {
            /* border-radius: 15px; */
            /* color: @base04; */
            background: transparent;
        }
        tooltip {
            background: #${config.lib.stylix.colors.base01};
            border-radius: 5px;
            border-width: 2px;
            border-style: solid;
            border-color: #${config.lib.stylix.colors.base07};
        }
        #network,
        #clock,
        #battery,
        #pulseaudio,
        #workspaces,
        #backlight,
        #memory,
        #tray,
        #window {
            padding: 4px 10px;
            background: shade(alpha(#${config.lib.stylix.colors.base00}, 0.9), 1);
            text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.377);
            color: #${config.lib.stylix.colors.base05};
            margin-top: 5px;
            margin-bottom: 5px;
            margin-left: 5px;
            margin-right: 5px;
            box-shadow: 1px 2px 2px #101010;
            border-radius: 8px;
        }
        #workspaces {
          font-size: 0px;
          padding: 6px 3px;
          border-radius: 20px;
        }
        #workspaces button {
            font-size: 0px;
            background-color: #${config.lib.stylix.colors.base07};
            padding: 0px 1px;
            margin: 0px 4px;
            border-radius: 20px;
            transition: all 0.25s cubic-bezier(0.55, -0.68, 0.48, 1.682);
        }
        #workspaces button.active {
            font-size: 1px;
            background-color: #${config.lib.stylix.colors.base0E};
            border-radius: 20px;
            min-width: 30px;
            background-size: 400% 400%;
        }
        #workspaces button.empty {
            font-size: 1px;
            background-color: #${config.lib.stylix.colors.base04};
        }
        #window {
          color: #${config.lib.stylix.colors.base00};
          background: radial-gradient(circle, #${config.lib.stylix.colors.base05} 0%, #${config.lib.stylix.colors.base07} 100%);
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
            background: #${config.lib.stylix.colors.base0F};
            /* background: linear-gradient(118deg, #${config.lib.stylix.colors.base07} 0%, #${config.lib.stylix.colors.base0F} 25%, #${config.lib.stylix.colors.base07} 50%, #${config.lib.stylix.colors.base0F} 75%, #${config.lib.stylix.colors.base07} 100%); */
            /* background: linear-gradient(118deg, #${config.lib.stylix.colors.base07} 5%, #${config.lib.stylix.colors.base0F} 5%, #${config.lib.stylix.colors.base0F} 20%, #${config.lib.stylix.colors.base07} 20%, #${config.lib.stylix.colors.base07} 40%, #${config.lib.stylix.colors.base0F} 40%, #${config.lib.stylix.colors.base0F} 60%, #${config.lib.stylix.colors.base07} 60%, #${config.lib.stylix.colors.base07} 80%, #${config.lib.stylix.colors.base0F} 80%, #${config.lib.stylix.colors.base0F} 95%, #${config.lib.stylix.colors.base07} 95%);  */
            background: linear-gradient(118deg, #${config.lib.stylix.colors.base0B} 5%, #${config.lib.stylix.colors.base0F} 5%, #${config.lib.stylix.colors.base0F} 20%, #${config.lib.stylix.colors.base0B} 20%, #${config.lib.stylix.colors.base0B} 40%, #${config.lib.stylix.colors.base0F} 40%, #${config.lib.stylix.colors.base0F} 60%, #${config.lib.stylix.colors.base0B} 60%, #${config.lib.stylix.colors.base0B} 80%, #${config.lib.stylix.colors.base0F} 80%, #${config.lib.stylix.colors.base0F} 95%, #${config.lib.stylix.colors.base0B} 95%);
            background-size: 200% 300%;
            animation: gradient_f_nh 4s linear infinite;
            color: #${config.lib.stylix.colors.base01};
        }
        #battery.charging, #battery.plugged {
            background: linear-gradient(118deg, #${config.lib.stylix.colors.base0E} 5%, #${config.lib.stylix.colors.base0D} 5%, #${config.lib.stylix.colors.base0D} 20%, #${config.lib.stylix.colors.base0E} 20%, #${config.lib.stylix.colors.base0E} 40%, #${config.lib.stylix.colors.base0D} 40%, #${config.lib.stylix.colors.base0D} 60%, #${config.lib.stylix.colors.base0E} 60%, #${config.lib.stylix.colors.base0E} 80%, #${config.lib.stylix.colors.base0D} 80%, #${config.lib.stylix.colors.base0D} 95%, #${config.lib.stylix.colors.base0E} 95%);
            background-size: 200% 300%;
            animation: gradient_rv 4s linear infinite;
        }
        #battery.full {
            background: linear-gradient(118deg, #${config.lib.stylix.colors.base0E} 5%, #${config.lib.stylix.colors.base0D} 5%, #${config.lib.stylix.colors.base0D} 20%, #${config.lib.stylix.colors.base0E} 20%, #${config.lib.stylix.colors.base0E} 40%, #${config.lib.stylix.colors.base0D} 40%, #${config.lib.stylix.colors.base0D} 60%, #${config.lib.stylix.colors.base0E} 60%, #${config.lib.stylix.colors.base0E} 80%, #${config.lib.stylix.colors.base0D} 80%, #${config.lib.stylix.colors.base0D} 95%, #${config.lib.stylix.colors.base0E} 95%);
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
    ".config/niri/waybar/animation.css".text =
      /*
      css
      */
      ''
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
  
  programs.niri.settings.spawn-at-startup = [
    {command = ["waybar"];}
  ];
}
