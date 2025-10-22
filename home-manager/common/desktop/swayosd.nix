{config, ...}: let
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
  services.swayosd = {
    enable = true;
    stylePath = "${config.xdg.configHome}/swayosd/style.scss";
    topMargin = 1.0;
  };

  xdg.configFile."swayosd/style.scss".text =
    # scss
    ''
      window {
        border-radius: 999px;
        border: 2px solid alpha(${gray2}, ${toString 0.85});
        background: alpha(${gray0}, ${toString 0.85});
      }

      image,
      label {
        color: ${white2};
      }

      progressbar {
        min-height: 6px;
        border-radius: 999px;
        background: transparent;
        border: none;
      }

      progressbar:disabled,
      image:disabled {
        opacity: 0.5;
      }

      trough {
        min-height: inherit;
        border-radius: inherit;
        border: none;
        background: alpha(${white2}, 0.5);
      }

      progress {
        min-height: inherit;
        border-radius: inherit;
        border: none;
        background: ${white2};
      }
    '';

  programs.niri.settings.binds = {
    "XF86AudioPlay" = {
      action.spawn = ["swayosd-client" "--monitor" "${config.lib.monitors.mainMonitorName}" "--playerctl=play-pause"];
      allow-when-locked = true;
    };
    "XF86AudioPause" = {
      action.spawn = ["swayosd-client" "--monitor" "${config.lib.monitors.mainMonitorName}" "--playerctl=play-pause"];
      allow-when-locked = true;
    };
    "XF86AudioNext" = {
      action.spawn = ["swayosd-client" "--monitor" "${config.lib.monitors.mainMonitorName}" "--playerctl=next"];
      allow-when-locked = true;
    };
    "XF86AudioPrev" = {
      action.spawn = ["swayosd-client" "--monitor" "${config.lib.monitors.mainMonitorName}" "--playerctl=previous"];
      allow-when-locked = true;
    };

    # fcitx5
    "Ctrl+Space" = {
      action.spawn = ["sh" "-c" "fcitx5-remote -t && swayosd-client --monitor ${config.lib.monitors.mainMonitorName} --custom-message=$(fcitx5-remote -n) --custom-icon=input-keyboard"];
      hotkey-overlay.title = ''<span foreground="${magenta_bright}">[Fcitx5]</span> Switch Active/Inactive'';
    };
  };
}
