{lib, ...}: let
  inherit (lib.generators) toINI;
in {
  programs.foot = {
    enable = true;
    settings = {
      main = {
        include = "~/.config/foot/themes/eldritch";
        font = "monospace:size=14";
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
      target = "foot/themes/eldritch";
      text = toINI {} {
        colors = {
          foreground = "ebfafa";
          background = "212337";
          regular0 = "21222c";
          regular1 = "f9515d";
          regular2 = "37f499";
          regular3 = "e9f941";
          regular4 = "9071f4";
          regular5 = "f265b5";
          regular6 = "04d1f9";
          regular7 = "ebfafa";
          bright0 = "7081d0";
          bright1 = "f16c75";
          bright2 = "69F8B3";
          bright3 = "f1fc79";
          bright4 = "a48cf2";
          bright5 = "FD92CE";
          bright6 = "66e4fd";
          bright7 = "ffffff";
          selection-foreground = "ebfafa";
          selection-background = "bf4f8e";
          cursor = "37f499 f8f8f2";
        };
      };
    };
  };
}
