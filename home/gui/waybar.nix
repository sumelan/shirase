{
  config,
  isNixOS,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.waybar;
in
{
  options.custom = with lib; {
    waybar = {
      enable = mkEnableOption "waybar" // {
        default = config.custom.hyprland.enable;
      };
      config = mkOption {
        type = types.submodule { freeformType = (pkgs.formats.json { }).type; };
        default = { };
        description = "Additional waybar config";
      };
      idleInhibitor = mkEnableOption "Idle inhibitor" // {
        default = true;
      };
      extraCss = mkOption {
        type = types.lines;
        default = "";
        description = "Additional css to add to the waybar style.css";
      };
      persistentWorkspaces = mkEnableOption "Persistent workspaces";
      hidden = mkEnableOption "Hidden waybar by default";
    };
  };

  config = lib.mkIf config.custom.waybar.enable {
    programs.waybar = {
      enable = isNixOS;
      package = pkgs.waybar.override { cavaSupport = false; };
      systemd.enable = true;
    };

    # toggle / launch waybar
    wayland.windowManager.hyprland.settings = {
      layerrule = [
        "blur,waybar"
        "ignorealpha 0,waybar"
      ];

      bind = [
        ''$mod, a, exec, ${lib.getExe' pkgs.procps "pkill"} -SIGUSR1 waybar''
        "$mod_SHIFT, a, exec, systemctl --user restart waybar.service"
      ];
    };

    custom = {
      waybar.config = {
        backlight = lib.mkIf config.custom.backlight.enable {
          format = "{icon}   {percent}%";
          format-icons = [
            "󰃞"
            "󰃟"
            "󰃝"
            "󰃠"
          ];
          on-scroll-down = "${lib.getExe pkgs.brightnessctl} s 1%-";
          on-scroll-up = "${lib.getExe pkgs.brightnessctl} s +1%";
        };

        battery = lib.mkIf config.custom.battery.enable {
          format = "{icon}    {capacity}%";
          format-charging = "     {capacity}%";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          states = {
            critical = 20;
          };
          tooltip = false;
        };

        clock = {
          calendar = {
            actions = {
              on-click-right = "mode";
              on-scroll-down = "shift_down";
              on-scroll-up = "shift_up";
            };
            format = {
              days = "<span color='{{color4}}'><b>{}</b></span>";
              months = "<span color='{{foreground}}'><b>{}</b></span>";
              today = "<span color='{{color3}}'><b><u>{}</u></b></span>";
              weekdays = "<span color='{{color5}}'><b>{}</b></span>";
            };
            mode = "year";
            mode-mon-col = 3;
            on-scroll = 1;
          };
          format = "󰥔   {:%H:%M}";
          format-alt = "󰸗   {:%a, %d %b %Y}";
          # format-alt = "  {:%a, %d %b %Y}";
          interval = 10;
          tooltip-format = "<tt><small>{calendar}</small></tt>";
        };

        "custom/nix" = {
          format = "󱄅";
          on-click = "rofi -show drun";
          tooltip = false;
        };

        idle_inhibitor = lib.mkIf cfg.idleInhibitor {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };

        "hyprland/workspaces" = {
          layer = "top";
          margin = "0";

          modules-center = [ "hyprland/workspaces" ];

          modules-left = [ "custom/nix" ] ++ (lib.optional cfg.idleInhibitor "idle_inhibitor");

          modules-right =
            [
              "network"
              "pulseaudio"
            ]
            ++ (lib.optional config.custom.backlight.enable "backlight")
            ++ (lib.optional config.custom.battery.enable "battery")
            ++ [ "clock" ];

          network =
            {
              format-disconnected = "󰖪    Offline";
              tooltip = false;
            }
            // (
              if config.custom.wifi.enable then
                {
                  format = "    {essid}";
                  format-ethernet = " ";
                  on-click-right = "${config.custom.terminal.exec} nmtui";
                }
              else
                { format-ethernet = ""; }
            );

          position = "top";

          pulseaudio = {
            format = "{icon}  {volume}%";
            format-icons = [
              "󰕿"
              "󰖀"
              "󰕾"
            ];
            format-muted = "󰖁  Muted";
            on-click = "${lib.getExe pkgs.pamixer} -t";
            on-click-right = "pwvucontrol";
            scroll-step = 1;
            tooltip = false;
          };

          start_hidden = cfg.hidden;
        };
      };
    };
  };
}
