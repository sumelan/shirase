{lib, ...}: let
  inherit (lib) singleton;
  inherit
    (lib.custom.colors)
    black0
    gray0
    white3
    blue0
    cyan_bright
    green_dim
    green_bright
    orange_bright
    red_bright
    ;
in {
  programs.niri.settings = {
    layout = {
      background-color = "transparent";
      gaps = 14;
      border.enable = false;
      focus-ring = {
        enable = true;
        width = 4;
        active.gradient = {
          from = green_bright;
          to = cyan_bright;
          relative-to = "window";
        };
        inactive.color = gray0;
      };
      struts = {
        left = 2;
        right = 2;
        top = 2;
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
      shadow = {
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
      tab-indicator = {
        enable = true;
        position = "left";
        hide-when-single-tab = true;
        place-within-column = true;
        active.color = blue0;
        inactive.color = gray0;
        gap = 5;
        width = 4;
        length.total-proportion = 0.5;
        gaps-between-tabs = 2;
      };
    };
    window-rules = [
      # global rules
      {
        geometry-corner-radius = {
          bottom-left = 20.0;
          bottom-right = 20.0;
          top-left = 20.0;
          top-right = 20.0;
        };
        # cut out any client-side window shadows, and also round window corners according to `geometry-corner-radius`
        clip-to-geometry = true;
        # Override whether the border and the focus ring draw with a background
        draw-border-with-background = false;
      }
      # focused and floating windows
      {
        matches = singleton {
          is-focused = true;
          is-floating = true;
        };
        opacity = 0.98;
        focus-ring.width = 2;
      }
      # focused but no-floating column/windows
      {
        matches = singleton {
          is-focused = true;
          is-floating = false;
        };
        opacity = 0.98;
        focus-ring.width = 4;
      }
      # no-focused but floating window
      {
        matches = singleton {
          is-focused = false;
          is-floating = true;
        };
        opacity = 0.95;
      }
      # no-focused and no-floating column/window
      {
        matches = singleton {
          is-focused = false;
          is-floating = false;
        };
        opacity = 0.90;
      }
      # Picture-in-pictures
      {
        matches = [
          {title = "^ピクチャーインピクチャー$";}
          {title = "^ピクチャー イン ピクチャー$";}
          {title = "^Picture-in-Picture$";}
        ];
        open-floating = true;
        opacity = 1.0;
      }
      # targeted column/window from screencast program, like obs
      {
        matches = singleton {
          is-window-cast-target = true;
        };
        focus-ring = {
          active.gradient = {
            from = orange_bright;
            to = red_bright;
            relative-to = "window";
          };
          inactive.color = gray0;
        };
        tab-indicator = {
          active.color = red_bright;
          inactive.color = gray0;
        };
        shadow = {
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
      }
      # hide gnome seahorse from screencast
      {
        matches = singleton {
          app-id = "^org.gnome.seahorse.Application$";
        };
        block-out-from = "screen-capture";
      }
    ];

    layer-rules = [
      {
        matches = singleton {
          namespace = "^noctalia-overview*";
        };
        place-within-backdrop = true;
      }
    ];
  };
}
