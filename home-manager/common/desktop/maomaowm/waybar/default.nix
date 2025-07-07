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

  programs = lib.mkIf config.custom.maomaowm.enable {
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
              "dwl/tags"
              "tray"
              "dwl/window"
            ];
            modules-center = [
              "clock"
              "memory"
            ];
            modules-right = [
              "network"
              "wireplumber"
              "backlight"
              "battery"
            ];
          };

          moduleConfiguration = with config.lib.stylix.colors.withHashtag; {
            "dwl/tags" = {
              tag-labels = [
                ""
                ""
                ""
                ""
                ""
                ""
                ""
                ""
                ""
              ];
            };
            "dwl/window" = {
              format = "{}";
              separate-outputs = true;
              icon = true;
              icon-size = 18;
            };
            "memory" = {
              interval = 30;
              format = "<span size='${iconSizeStr}' foreground='${base0E}'>  </span>  {used:0.1f}G/{total:0.1f}G";
              on-click = "${lib.getExe terminalPkgs} -T ' htop' --class=htop  ${lib.getExe pkgs.htop}";
            };
            "backlight" = {
              device = "intel_backlight";
              on-scroll-up = "${lib.getExe pkgs.brightnessctl} set +5";
              on-scroll-down = "${lib.getExe pkgs.brightnessctl} set 5-";
              format = "<span size='${iconSizeStr}' foreground='${base0A}'>{icon} </span> {percent}%";
              format-icons = [
                ""
                ""
              ];
              tooltip = false;
            };
            "tray" = {
              icon-size = 24;
              spacing = 10;
            };
            "clock" = {
              format = "<span size='${iconSizeStr}' foreground='${base0E}'> </span> {:%a %d %H:%M}";
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
              format-alt = "<span size='${iconSizeStr}' foreground='#${base01}'>{icon} </span>{time}";
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
              format-wifi = "<span size='${iconSizeStr}' foreground='${base06}'>󰖩  </span>{essid}";
              format-ethernet = "<span size='${iconSizeStr}' foreground='${base06}'>󰤭 </span> Disconnected";
              format-linked = "{ifname} (No IP) 󱚵 ";
              format-disconnected = "<span size='${iconSizeStr}' foreground='${base06}'> </span>Disconnected";
              tooltip-format-wifi = "Signal Strenght: {signalStrength}%";
              on-click = "${lib.getExe terminalPkgs} --class=nmtui  -T '󰖩 nmtui' sudo nmtui";
            };
            "idle_inhibitor" = {
              format = "{icon}";
              format-icons = {
                activated = "<span size='${iconSizeStr}' foreground='${base05}'>  </span>";
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
          };
        in
        {
          "mainBar" = mainBarConfig // moduleConfiguration;
        };
    };
  };
  stylix.targets.waybar.enable = false;
}
