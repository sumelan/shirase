{lib, ...}: let
  inherit (lib.generators) toINI;
in {
  programs.foot = {
    enable = true;
    settings = {
      main = {
        include = "~/.config/foot/themes/everforest";
        font = "monospace:size=15";
        initial-window-size-pixels = "1200x800";
      };
      scrollback = {
        lines = 10000;
      };
      cursor = {
        style = "beam";
        blink = "yes";
        blink-rate = 500;
        beam-thickness = 2.0;
      };
      mouse = {
        hide-when-typing = "yes";
      };
    };
  };

  xdg.configFile = {
    eldritch = {
      target = "foot/themes/everforest";
      text = toINI {} {
        colors = {
          alpha = 1.0;
          background = "323d43";
          foreground = "d3c6aa";

          regular0 = "4b565c"; # black
          regular1 = "e67e80"; # red
          regular2 = "a7c080"; # green
          regular3 = "dbbc7f"; # yellow
          regular4 = "7fbbb3"; # blue
          regular5 = "d699b6"; # magenta
          regular6 = "83c092"; # cyan
          regular7 = "d3c6aa"; # white

          bright0 = "4b565c"; # black
          bright1 = "e67e80"; # red
          bright2 = "a7c080"; # green
          bright3 = "dbbc7f"; # yellow
          bright4 = "7fbbb3"; # blue
          bright5 = "d699b6"; # magenta
          bright6 = "83c092"; # cyan
          bright7 = "d3c6aa"; # white
        };
      };
    };
  };
}
