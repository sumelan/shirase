{ config, ... }:
with config.lib.stylix.colors.withHashtag;
let
  left-click = 272;
  right-click = 273;
  middle-click = 274;
  side-click-1 = 275;
  side-click-2 = 276;

  commonConfig = edge: {
    namespace = "move-column";
    edge = "${edge}";
    layer = "overlay";
    extra-trigger-size = 0;
    preview-size = "25%";
    animation-curve = "ease-expo";
    transition-duration = 300;
    ignore-exclusive = true;
    pinnable = true;
    pin-with-key = true;
    pin-key = right-click;
  };

  btnConfig = color: color': {
    type = "btn";
    thickness = 15;
    length = "30%";
    color = "${color}";
    border-color = "${color'}";
    border-width = 3;
  };

  commonDown = position: {
    position = "${position}";
    monitor = [
      config.lib.monitors.mainMonitorName
    ] ++ config.lib.monitors.otherMonitorsNames;
    margins.${position} = "35%";
  };

  commonUp = position: {
    position = "${position}";
    monitor = [
      config.lib.monitors.mainMonitorName
    ] ++ config.lib.monitors.otherMonitorsNames;
    margins.${position} = "35%";
  };

  columnDown =
    commonConfig "bottom"
    // commonDown "left"
    // btnConfig "${base0E}" "${base05}"
    // {
      event-map = {
        ${builtins.toString left-click} = "niri msg action move-column-to-workspace-down";
        ${builtins.toString middle-click} = "niri msg action move-column-to-monitor-down";
      };
    };

  columnUp =
    commonConfig "top"
    // commonUp "right"
    // btnConfig "${base0D}" "${base05}"
    // {
      event-map = {
        ${builtins.toString left-click} = "niri msg action move-column-to-workspace-up";
        ${builtins.toString middle-click} = "niri msg action move-column-to-monitor-up";
      };
    };
in
[
  columnDown
  columnUp
]
