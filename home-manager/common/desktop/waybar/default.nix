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
            size = 50;
            tooltip = false;
            on-click = "fuzzel-actions";
          };
          "niri/workspaces" = {
            format = "{icon}";
            format-icons = {
              default = "";
            };
          };
          "mpris" = {
            player = "YoutubeMusic"; # to acquire player list, run 'playerctl --list-all'
            ignored-players = [ "firefox" ];
            format = "<span size='12000' foreground='#${config.lib.stylix.colors.base08}'>{player_icon} </span>MPRIS\n<span size='12000' foreground='#${config.lib.stylix.colors.base05}'>{status_icon} </span>{length}";
            player-icons = {
              mpd = "";
              YoutubeMusic = "";
            };
            status-icons = {
              playing = "";
              paused = "";
              stopped = "";

            };
            tooltip-format = "{title}\nby {artist}";
            artist-len = 10;
            title-len = 10;
            ellipsis = "...";
            on-scroll-up = "${lib.getExe' pkgs.playerctl "playerctl"} volume 0.1+";
            on-scroll-down = "${lib.getExe' pkgs.playerctl "playerctl"} volume 0.1-";
          };
          "backlight" = {
            device = "intel_backlight";
            on-scroll-up = "${lib.getExe' pkgs.brightnessctl "brightnessctl"} set +5";
            on-scroll-down = "${lib.getExe' pkgs.brightnessctl "brightnessctl"} set 5-";
            format = "<span size='12000' foreground='#${config.lib.stylix.colors.base0F}'>{icon} </span> {percent}%";
            format-icons = [
              ""
              ""
            ];
            tooltip = false;
          };
          "clock" = {
            format = "<span size='12000' foreground='#${config.lib.stylix.colors.base0E}'>󰥔 </span>{:%H:%M}";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            on-click = "kitty --class=tty-clock --title=tty-clock -e ${lib.getExe' pkgs.tty-clock "tty-clock"} -s -c -C 5";
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
          "bluetooth" = {
            format = "<span size='12000' foreground='#${config.lib.stylix.colors.base0D}'> </span> {status}";
            format-disabled = "";
            format-connected-battery = "<span size='12000' foreground='#${config.lib.stylix.colors.base0D}'>󰂱 </span> {device_battery_percentage}%";
            tooltip-format-connected = "{device_alias} - {num_connections} connected";
          };
          "network" = {
            format-wifi = "<span size='12000' foreground='#${config.lib.stylix.colors.base0B}'>󰖩 </span> {signalStrength}%";
            tooltip-format-wifi = "{ifname}: {essid} - {frequency} MHz";
            format-ethernet = "<span size='12000' foreground='#${config.lib.stylix.colors.base0B}'>󰈀 {ifname}</span>";
            format-linked = "(No IP) 󱚵";
            format-disconnected = "<span size='12000' foreground='#${config.lib.stylix.colors.base0B}'> </span>";
          };
          "wireplumber" = {
            format = "<span size='12000' foreground='#${config.lib.stylix.colors.base06}'>{icon} </span> {volume}%";
            format-muted = "<span size='12000' foreground='#${config.lib.stylix.colors.base06}'> </span>";
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
          modules-center = [
            "mpris"
          ];
          modules-right = [
            "bluetooth"
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
}
