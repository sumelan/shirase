{lib, ...}: let
  inherit (lib) singleton;

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

  shadowConfig = {
    enable = true;
    softness = 20;
    spread = 10;
    offset = {
      x = 0;
      y = 0;
    };
    draw-behind-window = false;
    color = black0 + "90";
  };
in {
  programs.niri.settings = {
    window-rules = [
      # global rules
      {
        geometry-corner-radius = {
          bottom-left = 20.0;
          bottom-right = 20.0;
          top-left = 20.0;
          top-right = 20.0;
        };
        clip-to-geometry = true;
        draw-border-with-background = false;
      }
      # focused column/window opacity
      {
        matches = singleton {
          is-focused = true;
        };
        opacity = 0.98;
      }
      # out-focued and no-floating column/window opacity
      {
        matches = singleton {
          is-focused = false;
          is-floating = false;
        };
        opacity = 0.98 * 0.9;
      }
      # Picture-in-pictures
      {
        matches = [
          {title = "^(ピクチャーインピクチャー)$";}
          {title = "^(ピクチャー イン ピクチャー)$";}
          {title = "^(Picture-in-Picture)$";}
        ];
        open-floating = true;
        opacity = 1.0;
      }
      # targeted column/window from screencast program, like obs
      {
        matches = singleton {
          is-window-cast-target = true;
        };
        border = {
          active.gradient = {
            from = red_dim;
            to = red_bright;
            relative-to = "window";
          };
          inactive.color = gray3;
        };
        tab-indicator = {
          active.color = orange_bright;
          inactive.color = gray3;
        };
        shadow = shadowConfig;
      }
      # hide gnome seahorse from screencast
      {
        matches = singleton {
          app-id = "^(org.gnome.seahorse.Application)$";
        };
        block-out-from = "screen-capture";
      }
    ];
  };
}
