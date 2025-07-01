{
  lib,
  config,
  pkgs,
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
          icon_size = builtins.toString 15000;
          moduleConfiguration = with config.lib.stylix.colors.withHashtag; {
            "image" = {
              path = "${config.home.homeDirectory}/.anime-logo.png";
              size = 32;
              tooltip = false;
              on-click = "${lib.getExe pkgs.killall} -SIGUSR1 .waybar-wrapped";
            };
            "niri/window" = {
              format = "{}";
              separate-outputs = true;
              icon = true;
              icon-size = 24;
              expand = false;
            };
            "backlight" = {
              device = "intel_backlight";
              on-scroll-up = "${lib.getExe pkgs.brightnessctl} set +5";
              on-scroll-down = "${lib.getExe pkgs.brightnessctl} set 5-";
              format = "<span size='${icon_size}' foreground='${base0A}'>{icon} </span> {percent}%";
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
              format = "<span size='${icon_size}' foreground='${base0E}'> </span> {:%a %d %H:%M}";
              tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
              on-click = "${config.custom.terminal.exec} -T ' tty-clock' --class=tty-clock ${lib.getExe pkgs.tty-clock} -s -c -C 5";
            };
            "battery" = {
              states = {
                warning = 30;
                critical = 15;
              };
              format = "<span size='${icon_size}' foreground='${base0B}'>{icon} </span>{capacity}%";
              format-warning = "<span size='${icon_size}' foreground='${base09}'>{icon} </span>{capacity}%";
              format-critical = "<span size='${icon_size}' foreground='${base08}'>{icon} </span>{capacity}%";
              format-charging = "<span size='${icon_size}' foreground='${base0B}'> </span>{capacity}%";
              format-plugged = "<span size='${icon_size}' foreground='${base0B}'> </span>{capacity}%";
              format-alt = "<span size='${icon_size}' foreground='#${base01}'>{icon} </span>{time}";
              format-full = "<span size='${icon_size}' foreground='${base08}'> </span>{capacity}%";
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
            "idle_inhibitor" = {
              format = "{icon}";
              format-icons = {
                activated = "<span size='${icon_size}' foreground='${base05}'>  </span>";
                deactivated = "<span size='${icon_size}' foreground='${base02}'>  </span>";
              };
              tooltip = false;
            };
            "wireplumber" = {
              format = "<span size='${icon_size}' foreground='${base06}'>{icon} </span>{volume}%";
              format-muted = "<span size='${icon_size}' foreground='${base06}'> </span>Muted";
              on-click = "${lib.getExe pkgs.pwvucontrol}";
              format-icons = [
                ""
                ""
              ];
            };
          };

          mainMonitorsConfig = {
            position = "top";
            layer = "top";
            mode = "hide";
            start_hidden = true;
            reload_style_on_change = true;
            output = "${config.lib.monitors.mainMonitorName}";
            modules-left = [
              "image"
              "clock"
              "tray"
              "idle_inhibitor"
            ];
            modules-center = [ ];
            modules-right = [ ];
          };
        in
        {
          "mainBar" = mainMonitorsConfig // moduleConfiguration;
        };
    };

    niri.settings.layer-rules = [
      {
        matches = [ { namespace = "^(waybar)$"; } ];
        opacity = config.stylix.opacity.desktop * 0.9;
      }
    ];
  };
  stylix.targets.waybar.enable = false;
}
