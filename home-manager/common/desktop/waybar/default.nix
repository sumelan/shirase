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
        moduleConfiguration = {
          "image" = {
            path = "/home/${user}/.themed-logo.png";
            size = 47;
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
            on-scroll-up = "${lib.getExe' pkgs.light "light"} -A 1";
            on-scroll-down = "${lib.getExe' pkgs.light "light"} -U 1";
            format = "<span size='12000' foreground='#${config.lib.stylix.colors.base0D}'>{icon} </span> {percent}%";
            format-icons = [
              ""
              ""
            ];
            tooltip = false;
          };
          "clock" = {
            format = "<span size='12000' foreground='#${config.lib.stylix.colors.base0E}'>󰥔 </span>{:%H:%M}";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            on-click = "kitty --class=tty-clock --title=tty-clock -e ${pkgs.tty-clock}/bin/tty-clock -s -c -C 5";
          };
          "battery" = {
            states = {
              warning = 30;
              critical = 15;
            };
            format = "<span size='12000' foreground='#${config.lib.stylix.colors.base0B}'>{icon} </span> {capacity}%";
            format-warning = "<span size='12000' foreground='#${config.lib.stylix.colors.base0B}'>{icon} </span> {capacity}%";
            format-critical = "<span size='12000' foreground='#${config.lib.stylix.colors.base08}'>{icon} </span> {capacity}%";
            format-charging = "<span size='12000' foreground='#${config.lib.stylix.colors.base0B}'> </span> {capacity}%";
            format-plugged = "<span size='12000' foreground='#${config.lib.stylix.colors.base0B}'> </span> {capacity}%";
            format-alt = "<span size='12000' foreground='#${config.lib.stylix.colors.base0B}'>{icon} </span> {time}";
            format-full = "<span size='12000' foreground='#${config.lib.stylix.colors.base0B}'> </span> {capacity}%";
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
            format-wifi = "<span size='12000' foreground='#${config.lib.stylix.colors.base0B}'>󰖩 </span> {signalStrength}%";
            format-ethernet = "<span size='12000' foreground='#${config.lib.stylix.colors.base0B}'>󰈀 </span>";
            format-linked = "{ifname} (No IP) 󱚵";
            format-disconnected = "<span size='12000' foreground='#${config.lib.stylix.colors.base0B}'> </span>";
          };
          "wireplumber" = {
            format = "<span size='12000' foreground='#${config.lib.stylix.colors.base0A}'>{icon} </span> {volume}%";
            format-muted = "<span size='12000' foreground='#${config.lib.stylix.colors.base0A}'> </span>";
            on-click = "pwvucontrol";
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
          modules-right = [
            "network"
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

  custom.persist = {
    home.cache.directories = [
      ".cache/update-checker"
    ];
  };
}
