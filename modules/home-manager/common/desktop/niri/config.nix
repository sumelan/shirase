# niri will already automatically turn the internal laptop monitor on and off in accordance with the laptop lid.
{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) getExe mkEnableOption;
  inherit (lib.custom.colors) black0 gray2;
in {
  options.custom = {
    niri.xwayland.enable = mkEnableOption "xwayland-satellite";
  };

  config = {
    programs.niri.settings = {
      hotkey-overlay = {
        skip-at-startup = true;
        hide-not-bound = true;
      };

      # omit their client-side decorations.
      prefer-no-csd = true;

      screenshot-path = "${config.xdg.userDirs.pictures}/Screenshots/%Y-%m-%d %H-%M-%S.png";

      xwayland-satellite = {
        inherit (config.custom.niri.xwayland) enable;
        path = getExe pkgs.xwayland-satellite-unstable;
      };

      input = {
        focus-follows-mouse.enable = true;
        touchpad.natural-scroll = true;
        # niri handle power button as sleep by default
        power-key-handling.enable = true;
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

      overview = {
        backdrop-color = gray2;
        workspace-shadow = {
          enable = true;
          color = black0 + "90";
        };
        # zoom ranges from 0 to 0.75 where lower values make everything smaller.
        zoom = 0.500;
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
