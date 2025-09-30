{
  lib,
  config,
  ...
}: let
  inherit
    (lib)
    singleton
    ;

  inherit
    (config.lib.stylix.colors.withHashtag)
    base08
    base09
    base0A
    base0F
    ;

  shadowConfig = {
    enable = true;
    spread = 0;
    softness = 10;
    color = "#000000dd";
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
        opacity = config.stylix.opacity.desktop;
      }
      # out-focued and no-floating column/window opacity
      {
        matches = singleton {
          is-focused = false;
          is-floating = false;
        };
        opacity = config.stylix.opacity.desktop * 0.9;
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
          active.color = base08;
          inactive.color = base0A;
        };
        tab-indicator = {
          active.color = base09;
          inactive.color = base0F;
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
