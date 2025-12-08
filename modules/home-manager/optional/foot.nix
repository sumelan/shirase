{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.generators) toINI;
in {
  options.custom = {
    foot.enable = mkEnableOption "foot";
  };

  config = mkIf config.custom.foot.enable {
    programs = {
      foot = {
        enable = true;
        settings = {
          main = {
            include = "~/.config/foot/themes/nord";
            font = "monospace:size=14";
            initial-window-size-pixels = "1000x800";
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
    };

    xdg.configFile = {
      nord = {
        target = "foot/themes/nord";
        text = toINI {} {
          colors = {
            foreground = "d8dee9";
            background = "2e3440";
            regular0 = "3b4252";
            regular1 = "bf616a";
            regular2 = "a3be8c";
            regular3 = "ebcb8b";
            regular4 = "81a1c1";
            regular5 = "b48ead";
            regular6 = "88c0d0";
            regular7 = "e5e9f0";
            bright0 = "596377";
            bright1 = "bf616a";
            bright2 = "a3be8c";
            bright3 = "ebcb8b";
            bright4 = "81a1c1";
            bright5 = "b48ead";
            bright6 = "8fbcbb";
            bright7 = "eceff4";
            selection-foreground = "4c566a";
            selection-background = "eceff4";
            cursor = "282828 eceff4";
          };
        };
      };
    };
  };
}
