{
  lib,
  config,
  ...
}: let
  inherit (lib) singleton;
  inherit
    (lib.custom.colors)
    black0
    gray3
    white3
    blue0
    cyan_base
    green_base
    red_base
    orange_base
    magenta_base
    yellow_base
    ;
in {
  programs = {
    satty = {
      enable = true;
      settings = {
        general = {
          # Start Satty in fullscreen mode
          fullscreen = false;
          # Exit directly after copy/save action
          early-exit = true;
          # Draw corners of rectangles round if the value is greater than 0 (0 disables rounded corners)
          corner-roundness = 12;
          # Select the tool on startup [possible values: pointer, crop, line, arrow, rectangle, text, marker, blur, brush]
          initial-tool = "brush";
          # Configure the command to be called on copy, for example `wl-copy`
          copy-command = "wl-copy";
          # Increase or decrease the size of the annotations
          annotation-size-factor = 2;
          # Filename to use for saving action. Omit to disable saving to file. Might contain format specifiers: https://docs.rs/chrono/latest/chrono/format/strftime/index.html
          # starting with 0.20.0, can contain leading tilde (~) for home directory
          output-filename = "${config.xdg.userDirs.pictures}/Satty/%Y-%m-%d_%H-%M-%S.png";
          # After copying the screenshot, save it to a file as well
          save-after-copy = false;
          # Hide toolbars by default
          default-hide-toolbars = false;
          # Experimental (since 0.20.0): whether window focus shows/hides toolbars. This does not affect initial state of toolbars, see default-hide-toolbars.
          focus-toggles-toolbars = false;
          # Fill shapes by default (since 0.20.0)
          default-fill-shapes = false;
          # The primary highlighter to use, the other is accessible by holding CTRL at the start of a highlight [possible values: block, freehand]
          primary-highlighter = "block";
          # Disable notifications
          disable-notifications = false;
          # Actions to trigger on right click (order is important)
          # [possible values: save-to-clipboard, save-to-file, exit]
          actions-on-right-click = [];
          # Actions to trigger on Enter key (order is important)
          # [possible values: save-to-clipboard, save-to-file, exit]
          actions-on-enter = ["save-to-clipboard"];
          # Actions to trigger on Escape key (order is important)
          # [possible values: save-to-clipboard, save-to-file, exit]
          actions-on-escape = ["exit"];
          # Action to perform when the Enter key is pressed [possible values: save-to-clipboard, save-to-file]
          # request no window decoration. Please note that the compositor has the final say in this. At this point. requires xdg-decoration-unstable-v1.
          no-window-decoration = true;
          # experimental feature: adjust history size for brush input smooting (0: disabled, default: 0, try e.g. 5 or 10)
          brush-smooth-history-size = 10;
          # experimental feature (NEXTRELEASE): The pan step size to use when panning with arrow keys.
          # pan-step-size = 50.0;
          # experimental feature (NEXTRELEASE): The zoom factor to use for the image.
          # 1.0 means no zooming.
          # zoom-factor = 1.1;
        };
        keybinds = {
          pointer = "p";
          crop = "c";
          brush = "b";
          line = "i";
          arrow = "z";
          rectangle = "r";
          ellipse = "e";
          text = "t";
          marker = "m";
          blur = "u";
          highlight = "g";
        };
        font = {
          family = config.custom.fonts.regular;
          style = "Regular";
        };

        color-palette = {
          palette = [
            black0
            gray3
            white3
            blue0
            cyan_base
            green_base
            red_base
            orange_base
            magenta_base
            yellow_base
          ];
        };
      };
    };

    niri.settings = {
      window-rules = [
        {
          matches = singleton {
            app-id = "^com.gabm.satty$";
          };
          open-floating = true;
          default-column-width.proportion = 0.50;
          default-window-height.proportion = 0.50;
          opacity = 1.0;
        }
      ];
    };
  };
}
