{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit
    (lib)
    getExe
    getExe'
    mkEnableOption
    mkIf
    ;
  base01 = "#212337";
  base05 = "#ebfafa";
  base0B = "#37f499";
  base0C = "#f7c67f";
  base0F = "#f1fc79";
in {
  options.custom = {
    niri = {
      xwayland.enable = mkEnableOption "Enable xwayland-satellite";
    };
  };

  config = {
    programs.niri.settings = let
      shadowConfig = {
        enable = true;
        softness = 20;
        spread = 10;
        offset = {
          x = 0;
          y = 0;
        };
        draw-behind-window = false;
        color = base05 + "90";
      };
    in {
      hotkey-overlay = {
        skip-at-startup = true;
        hide-not-bound = true;
      };

      config-notification.disable-failed = true;

      prefer-no-csd = true;

      xwayland-satellite = mkIf config.custom.niri.xwayland.enable {
        enable = true;
        path = getExe pkgs.xwayland-satellite-unstable;
      };

      input = {
        focus-follows-mouse.enable = true;
        touchpad.natural-scroll = true;
        power-key-handling.enable = false; # niri handle power button as sleep by default
      };

      cursor = {
        theme = config.home.pointerCursor.name;
        inherit (config.home.pointerCursor) size;
      };

      # apply function f to every element of attrset
      outputs =
        builtins.mapAttrs (_name: value: {
          inherit (value) scale mode position;
          transform.rotation = value.rotation;
        })
        config.monitors;

      gestures = {
        dnd-edge-view-scroll = {
          trigger-width = 60;
          delay-ms = 100;
          max-speed = 1500;
        };
      };

      layout = {
        background-color = "transparent";
        gaps = 12;
        border = {
          enable = true;
          width = 3;
          active = {
            gradient = {
              from = base0C;
              to = base0F;
              angle = 45;
              in' = "oklab";
            };
          };
          inactive.color = base01;
        };

        focus-ring.enable = false;

        struts = {
          left = 2;
          right = 2;
          top = 0;
          bottom = 2;
        };

        insert-hint = {
          enable = true;
          display = {
            gradient = {
              from = base0F;
              to = base0B;
              angle = 45;
            };
          };
        };

        shadow = shadowConfig;

        tab-indicator = {
          enable = true;
          position = "left";
          hide-when-single-tab = true;
          place-within-column = true;
          active.color = base0B;
          inactive.color = base01;
          gap = 5;
          width = 6;
          length.total-proportion = 0.5;
          gaps-between-tabs = 2;
        };
      };

      overview = {
        backdrop-color = base01;
        workspace-shadow = {
          enable = true;
          color = "#000000dd";
        };
        zoom = 0.5; # zoom ranges from 0 to 0.75 where lower values make everything smaller.
      };

      switch-events = {
        lid-close = {
          action.spawn = ["${getExe' pkgs.systemd "systemctl"}" "suspend"];
        };
        lid-open = {
          action.spawn = ["${getExe config.programs.niri.package}" "msg" "action" "power-on-monitors"];
        };
      };

      environment = {
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
        QT_QPA_PLATFORM = "wayland";
        QT_QPA_PLATFORMTHEME = "qt5ct";
        QT_QPA_PLATFORMTHEME_QT6 = "qt6ct";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        QT_STYLE_OVERRIDE = "kvantum";
        XDG_SESSION_TYPE = "wayland";
        XDG_CURRENT_DESKTOP = "niri";
        GDK_BACKEND = "wayland";
      };
    };
  };
}
