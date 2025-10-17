{lib, ...}: let
  inherit
    (lib)
    singleton
    ;
  base01 = "#212337";
  base05 = "#ebfafa";
  base09 = "#f16c75";
  base0D = "#f265b5";

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
        opacity = 0.95;
      }
      # out-focued and no-floating column/window opacity
      {
        matches = singleton {
          is-focused = false;
          is-floating = false;
        };
        opacity = 0.95 * 0.9;
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
          active.color = base09;
          inactive.color = base01;
        };
        tab-indicator = {
          active.color = base0D;
          inactive.color = base01;
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
