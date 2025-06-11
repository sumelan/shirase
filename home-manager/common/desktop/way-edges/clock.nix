{ config, ... }:
with config.lib.stylix.colors.withHashtag;
let
  left-click = 272;
  right-click = 273;
  middle-click = 274;
  side-click-1 = 275;
  side-click-2 = 276;

  clockConfig = {
    name = "clock";
    edge = "top";
    position = "right";
    layer = "overlay";
    monitor = config.lib.monitors.mainMonitorName;
    extra-trigger-size = 0;
    preview-size = "15%";
    animation-curve = "ease-expo";
    transition-duration = 300;
    margins.right = 0;
    ignore-exclusive = false;
    pinnable = true;
    pin-with-key = true;
    pin-key = right-click;
    type = "wrap-box";
    align = "center-right";
    gap = 10;
    outlook = {
      type = "window";
      color = "${base00}";
      border-radius = 5;
      border-width = 8;
      margins = {
        left = 5;
        right = 5;
        bottom = 5;
        top = 5;
      };
    };
    items = [
      {
        index = [
          (-1)
          (-1)
        ];
        type = "text";
        fg-color = "${base05}";
        font-family = "monospace";
        font-size = 24;
        preset = {
          type = "time";
          format = " %H:%M";
          time-zone = null;
          update-interval = 1000;
        };
      }
    ];
  };
in
[
  clockConfig
]
