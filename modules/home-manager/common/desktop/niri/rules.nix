{lib, ...}: let
  inherit (lib) singleton;
  inherit
    (lib.custom.colors)
    gray0
    white3
    orange_bright
    red_bright
    ;
in {
  programs.niri.settings = {
    window-rules = [
      # global rules
      {
        geometry-corner-radius = {
          bottom-left = 10.0;
          bottom-right = 10.0;
          top-left = 10.0;
          top-right = 10.0;
        };
        # cut out any client-side window shadows, and also round window corners according to `geometry-corner-radius`
        clip-to-geometry = true;
        # Override whether the border and the focus ring draw with a background
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
  };
}
