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
    ;
  # Black
  black0 = "#191D24";
  black1 = "#1E222A";
  black2 = "#222630";

  # Gray
  gray0 = "#242933";
  # Polar night
  gray1 = "#2E3440";
  gray2 = "#3B4252";
  gray3 = "#434C5E";
  gray4 = "#4C566A";
  # a light blue/gray
  # from @nightfox.nvim
  gray5 = "#60728A";

  # White
  # reduce_blue variant
  white0 = "#C0C8D8";
  # Snow storm
  white1 = "#D8DEE9";
  white2 = "#E5E9F0";
  white3 = "#ECEFF4";

  # Blue
  # Frost
  blue0 = "#5E81AC";
  blue1 = "#81A1C1";
  blue2 = "#88C0D0";

  # Cyan:
  cyan_base = "#8FBCBB";
  cyan_bright = "#9FC6C5";
  cyan_dim = "#80B3B2";

  # Aurora (from Nord theme)
  # Red
  red_base = "#BF616A";
  red_bright = "#C5727A";
  red_dim = "#B74E58";

  # Orange
  orange_base = "#D08770";
  orange_bright = "#D79784";
  orange_dim = "#CB775D";

  # Yellow
  yellow_base = "#EBCB8B";
  yellow_bright = "#EFD49F";
  yellow_dim = "#E7C173";

  # Green
  green_base = "#A3BE8C";
  green_bright = "#B1C89D";
  green_dim = "#97B67C";

  # Magenta
  magenta_base = "#B48EAD";
  magenta_bright = "#BE9DB8";
  magenta_dim = "#A97EA1";
in {
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

    xwayland-satellite = {
      enable = false;
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
        active.color = blue0;
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
            to = cyan_dim;
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
      zoom = 0.700; # zoom ranges from 0 to 0.75 where lower values make everything smaller.
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
}
