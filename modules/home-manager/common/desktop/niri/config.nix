{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) getExe mkEnableOption;

  inherit
    (lib.custom.colors)
    gray0
    gray2
    white3
    blue0
    blue2
    green_dim
    green_bright
    ;
in {
  options.custom = {
    niri.xwayland.enable = mkEnableOption "xwayland-satellite";
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
        color = white3 + "90";
      };
    in {
      hotkey-overlay = {
        skip-at-startup = true;
        hide-not-bound = true;
      };

      prefer-no-csd = true;

      screenshot-path = "${config.xdg.userDirs.pictures}/Screenshots/%Y-%m-%d %H-%M-%S.png";

      xwayland-satellite = {
        inherit (config.custom.niri.xwayland) enable;
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
          width = 5;
          active.gradient = {
            from = blue0;
            to = blue2;
            relative-to = "window";
          };
          inactive.color = gray0;
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
              from = green_dim;
              to = green_bright;
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
          active.color = green_bright;
          inactive.color = gray0;
          gap = 5;
          width = 6;
          length.total-proportion = 0.5;
          gaps-between-tabs = 2;
        };
      };

      overview = {
        backdrop-color = gray2;
        workspace-shadow = {
          enable = true;
          color = "#000000dd";
        };
        zoom = 0.500; # zoom ranges from 0 to 0.75 where lower values make everything smaller.
      };

      switch-events = {
        lid-close = {
          action.spawn = ["${pkgs.systemd}/bin/systemctl" "suspend"];
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
