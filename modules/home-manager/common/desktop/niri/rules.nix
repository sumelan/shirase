{lib, ...}: let
  inherit (lib) singleton;

  inherit
    (lib.custom.colors)
    black0
    gray3
    red_dim
    red_bright
    orange_bright
    ;

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
