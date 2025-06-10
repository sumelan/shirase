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
  programs = {
    waybar = {
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
              size = 32;
              tooltip = false;
              on-click = "fuzzel-actions";
            };
            "niri/window" = {
              format = "{}";
              separate-outputs = true;
              icon = true;
              icon-size = 24;
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
              on-click = "${config.custom.terminal.exec} --class=tty-clock --title=tty-clock -e ${lib.getExe pkgs.tty-clock} -s -c -C 5";
            };
            "idle_inhibitor" = {
              format = "{icon}";
              format-icons = {
                activated = "<span size='${icon_size}' foreground='${base05}'></span>";
                deactivated = "<span size='${icon_size}' foreground='${base03}'></span>";
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
            reload_style_on_change = true;
            output = "${config.lib.monitors.mainMonitorName}";
            modules-left = [
              "image"
              "niri/window"
            ];
            modules-center = [
              "clock"
            ];
            modules-right = [
              "idle_inhibitor"
              "tray"
              "wireplumber"
            ] ++ (lib.optional config.custom.backlight.enable "backlight");
          };
        in
        {
          "mainBar" = mainMonitorsConfig // moduleConfiguration;
        };
    };

    niri.settings.layer-rules = [
      {
        matches = [ { namespace = "^(waybar)$"; } ];
        opacity = config.stylix.opacity.desktop;
      }
    ];
  };
}
