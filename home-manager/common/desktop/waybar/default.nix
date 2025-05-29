{
  lib,
  config,
  pkgs,
  user,
  ...
}:
# NOTE: multiple waybar setting using HM is complicated!
{
  imports = [
    ./style.nix
  ];

  home.packages = with pkgs; [ brightnessctl ];

  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = config.wayland.systemd.target;
    };
    settings =
      let
        icon_size = builtins.toString 15000;

        moduleConfiguration = with config.lib.stylix.colors.withHashtag; {
          "image" = {
            path = "/home/${user}/.themed-logo.png";
            size = 30;
            tooltip = false;
            on-click = "fuzzel-actions";
          };
          "niri/workspaces" = {
            format = "{icon}";
            format-icons = {
              default = "";
            };
          };
          "backlight" = {
            device = "intel_backlight";
            on-scroll-up = "${lib.getExe' pkgs.brightnessctl "brightnessctl"} set +5";
            on-scroll-down = "${lib.getExe' pkgs.brightnessctl "brightnessctl"} set 5-";
            format = "<span size='${icon_size}' foreground='${base0F}'>{icon}</span>\n{percent}%";
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
            format = "<span size='${icon_size}' foreground='${base0E}'>󰥔</span>\n{:%H\n%M}";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            on-click = "kitty --class=tty-clock --title=tty-clock -e ${lib.getExe' pkgs.tty-clock "tty-clock"} -s -c -C 5";
          };
          "battery" = {
            states = {
              warning = 30;
              critical = 15;
            };
            format = "<span size='${icon_size}' foreground='${base0B}'>{icon}</span>\n{capacity}%";
            format-warning = "<span size='${icon_size}' foreground='${base0B}'>{icon}</span>\n{capacity}%";
            format-critical = "<span size='${icon_size}' foreground='${base08}'>{icon}</span>\n{capacity}%";
            format-charging = "<span size='${icon_size}' foreground='${base0B}'></span>\n{capacity}%";
            format-plugged = "<span size='${icon_size}' foreground='${base0B}'></span>\n{capacity}%";
            format-full = "<span size='${icon_size}' foreground='${base0B}'></span>\n{capacity}%";
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
          "wireplumber" = {
            format = "<span size='${icon_size}' foreground='${base06}'>{icon}</span>\n{volume}%";
            format-muted = "<span size='${icon_size}' foreground='${base06}'></span>";
            on-click = "${lib.getExe' pkgs.pwvucontrol "pwvucontrol"}";
            format-icons = [
              ""
              ""
            ];
          };
        };

        mainMonitorsConfig = {
          position = "left";
          layer = "top";
          reload_style_on_change = true;
          output = "${config.lib.monitors.mainMonitorName}";
          modules-left = [
            "image"
            "niri/workspaces"
          ];
          modules-center = [ ];
          modules-right = [
            "tray"
            "wireplumber"
            "backlight"
            "battery"
            "clock"
          ];
        };
      in
      {
        "mainBar" = mainMonitorsConfig // moduleConfiguration;
      };
  };
}
