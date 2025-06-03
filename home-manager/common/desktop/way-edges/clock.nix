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
    extra_trigger_size = 0;
    preview_size = "15%";
    animation_curve = "ease-expo";
    transition_duration = 300;
    margins.right = 0;
    ignore_exclusive = false;
    pinnable = true;
    pin-with-key = true;
    pin_key = right-click;
    widget = {
      type = "wrap-box";
      align = "center_right";
      gap = 10;
      outlook = {
        type = "window";
        color = "${base00}";
        border_radius = 5;
        border_width = 8;
        margins = {
          left = 5;
          right = 5;
          bottom = 5;
          top = 5;
        };
      };
      widgets = [
        {
          index = [
            (-1)
            (-1)
          ];
          widget = {
            type = "text";
            fg_color = "${base05}";
            font_family = "monospace";
            font_size = 24;
            preset = {
              type = "time";
              format = " %H:%M";
              time_zone = null;
              update_interval = 1000;
            };
          };
        }
      ];
    };
  };
in
[
  clockConfig
]
