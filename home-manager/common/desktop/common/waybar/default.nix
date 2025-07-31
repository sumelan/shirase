{
  lib,
  config,
  pkgs,
  user,
  ...
}:
{
  imports = [
    ./style.nix
  ];

  programs = {
    waybar = {
      enable = true;
      systemd = {
        enable = true;
        inherit (config.wayland.systemd) target;
      };
      settings =
        let
          iconSizeStr = builtins.toString 15000;
          terminalPkgs = config.profiles.${user}.defaultTerminal.package;

          mainBarConfig = {
            position = "top";
            layer = "top";
            reload_style_on_change = true;
            output = "${config.lib.monitors.mainMonitorName}";
            modules-left = [
              "niri/workspaces"
              "tray"
              "cava"
            ];
            modules-center = [
              "clock"
              "mpris"
              "memory"
            ];
            modules-right = [
              "idle_inhibitor"
              "network"
              "bluetooth"
              "wireplumber"
            ]
            ++ (lib.optionals config.custom.battery.enable [
              "power-profiles-daemon"
              "battery"
            ]);
          };

          moduleConfiguration = with config.lib.stylix.colors.withHashtag; {
            "niri/workspaces" = {
              format = "{icon}";
              format-icons = {
                default = "";
              };
            };
            "niri/window" = {
              format = "{}";
              separate-outputs = true;
              icon = true;
              icon-size = 24;
              expand = false;
            };
            "memory" = {
              interval = 30;
              format = "<span size='${iconSizeStr}' foreground='${base0E}'> </span>{used:0.1f}G/{total:0.1f}G";
              on-click = "${lib.getExe terminalPkgs} -T ' htop' --class=htop  ${lib.getExe pkgs.htop}";
            };
            "backlight" = {
              device = "intel_backlight";
              on-scroll-up = "${lib.getExe pkgs.brightnessctl} set +5";
              on-scroll-down = "${lib.getExe pkgs.brightnessctl} set 5-";
              format = "<span size='${iconSizeStr}' foreground='${base0A}'>{icon} </span>{percent}%";
              format-icons = [
                ""
                ""
              ];
              tooltip = false;
            };
            "clock" = {
              format = "<span size='${iconSizeStr}' foreground='${base0A}'> </span>{:%a %d %H:%M}";
              tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
              on-click = "${lib.getExe terminalPkgs} -T ' tty-clock' --class=tty-clock ${lib.getExe pkgs.tty-clock} -s -c -C 5";
            };
            "battery" = {
              states = {
                warning = 30;
                critical = 15;
              };
              format = "<span size='${iconSizeStr}' foreground='${base0B}'>{icon} </span>{capacity}%";
              format-warning = "<span size='${iconSizeStr}' foreground='${base09}'>{icon} </span>{capacity}%";
              format-critical = "<span size='${iconSizeStr}' foreground='${base08}'>{icon} </span>{capacity}%";
              format-charging = "<span size='${iconSizeStr}' foreground='${base0B}'> </span>{capacity}%";
              format-plugged = "<span size='${iconSizeStr}' foreground='${base0B}'> </span>{capacity}%";
              format-full = "<span size='${iconSizeStr}' foreground='${base08}'> </span>{capacity}%";
              format-icons = [
                ""
                ""
                ""
                ""
                ""
              ];
              tooltip-format = "{time}";
              interval = 5;
            };
            "network" = {
              format-wifi = "<span size='${iconSizeStr}' foreground='${base0B}'>󰖩 </span>{essid}";
              format-ethernet = "<span size='${iconSizeStr}' foreground='${base05}'>󰈀 </span>Connected";
              format-linked = "{ifname} (No IP) 󱚵 ";
              format-disconnected = "<span size='${iconSizeStr}' foreground='${base08}'> </span>Disconnected";
              tooltip-format-wifi = "Signal Strenght: {signalStrength}%";
              on-click = "${lib.getExe' pkgs.networkmanagerapplet "nm-connection-editor"}";
            };
            "idle_inhibitor" = {
              format = "{icon}";
              format-icons = {
                activated = "<span size='${iconSizeStr}' foreground='${base00}'>  </span>";
                deactivated = "<span size='${iconSizeStr}' foreground='${base02}'>  </span>";
              };
              tooltip = false;
            };
            "wireplumber" = {
              format = "<span size='${iconSizeStr}' foreground='${base06}'>{icon} </span>{volume}%";
              format-muted = "<span size='${iconSizeStr}' foreground='${base06}'> </span>Muted";
              on-click = "${lib.getExe pkgs.pwvucontrol}";
              format-icons = {
                headphone = "󱡏";
                hands-free = "";
                headset = "󱡏";
                phone = "";
                portable = "";
                car = "";
                default = [
                  ""
                  ""
                ];
              };
            };
            "bluetooth" = {
              format = "<span size='${iconSizeStr}' foreground='${base0D}'> </span>{status}";
              format-disabled = ""; # an empty format will hide the modules-left
              format-connected = "<span size='${iconSizeStr}' foreground='${base0D}'>󰂱 </span>";
              format-connected-battery = "<span size='${iconSizeStr}' foreground='${base0D}'>󰥈 </span>{device_battery_percentage}%";
              tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
              tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
              tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
              tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
              on-click = "${lib.getExe' pkgs.blueman "blueman-manager"}";
            };
            "tray" = {
              icon-size = 24;
              spacing = 10;
            };
            "mpris" = {
              player = "mpd";
              format = "<span size='${iconSizeStr}' foreground='${base09}'>{player_icon} </span><span weight='bold' foreground='${base07}'>{artist}</span> <span foreground='${base03}'>-</span> <span weight='bold' foreground='${base0E}'>{title}</span>";
              tooltip-format = "Album: {album}";
              artist-len = 14;
              title-len = 20;
              ellipsis = "...";
              player-icons = {
                default = "▶";
                mpd = "";
                kdeconnect = "";
              };
              on-scroll-up = "${lib.getExe pkgs.playerctl} volume 0.1+";
              on-scroll-down = "${lib.getExe pkgs.playerctl} volume 0.1-";
            };
            "power-profiles-daemon" = {
              format = "{icon}";
              tooltip-format = "Power profile: {profile}\nDriver: {driver}";
              tooltip = true;
              format-icons = {
                default = "";
                performance = "<span size='${iconSizeStr}' foreground='${base05}'> </span>";
                balanced = "<span size='${iconSizeStr}' foreground='${base0A}'> </span>";
                power-saver = "<span size='${iconSizeStr}' foreground='${base0B}'> </span>";
              };
            };
            "cava" = {
              # "cava_config": "$XDG_CONFIG_HOME/cava/cava.conf",
              framerate = 30;
              autosens = 1;
              bars = 15;
              lower_cutoff_freq = 50;
              higher_cutoff_freq = 10000;
              sleep_timer = 5;
              hide_on_silence = true;
              # "format_silent": "quiet",
              method = "pipewire";
              source = "auto";
              stereo = true;
              reverse = false;
              bar_delimiter = 0;
              monstercat = false;
              waves = false;
              noise_reduction = 0.77;
              input_delay = 2;
              format-icons = [
                "<span size='10000'>▁</span>"
                "<span size='10000'>▂</span>"
                "<span size='10000'>▃</span>"
                "<span size='10000'>▄</span>"
                "<span size='10000'>▅</span>"
                "<span size='10000'>▆</span>"
                "<span size='10000'>▇</span>"
                "<span size='10000'>█</span>"
              ];
              actions = {
                on-click-right = "mode";
              };
            };
          };
        in
        {
          "mainBar" = mainBarConfig // moduleConfiguration;
        };
    };
  };
  stylix.targets.waybar.enable = false;
}
