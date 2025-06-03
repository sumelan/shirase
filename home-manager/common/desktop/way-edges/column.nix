{ config, ... }:
with config.lib.stylix.colors.withHashtag;
let
  left-click = 272;
  right-click = 273;
  middle-click = 274;
  side-click-1 = 275;
  side-click-2 = 276;

  columnTransition = direction: color: {
    name = "focus-workspace-${direction}";
    edge = "top";
    position = "${direction}";
    layer = "overlay";
    monitor = config.lib.monitors.mainMonitorName;
    extra_trigger_size = 0;
    preview_size = "24%";
    animation_curve = "ease-expo";
    transition_duration = 300;
    margins.${direction} = "15%";
    ignore_exclusive = true;
    pinnable = true;
    pin-with-key = true;
    pin_key = right-click;
    widget = {
      type = "btn";
      thickness = 15;
      length = "18%";
      color = "${color}";
      border_width = 2;
      border_color = "${base09}";
      event_map = {
        ${builtins.toString left-click} = "niri msg action focus-column-${direction}";
      };
    };
  };
in
[
  (columnTransition "left" "${base0E}")
  (columnTransition "right" "${base0D}")
]
