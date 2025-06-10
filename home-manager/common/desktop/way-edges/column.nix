{
  lib,
  config,
  ...
}:
with config.lib.stylix.colors.withHashtag;
let
  left-click = 272;
  right-click = 273;
  middle-click = 274;
  side-click-1 = 275;
  side-click-2 = 276;

  commonConfig = edge: {
    name = "move_column";
    edge = "${edge}";
    layer = "overlay";
    extra_trigger_size = 0;
    preview_size = "25%";
    animation_curve = "ease-expo";
    transition_duration = 300;
    ignore_exclusive = true;
    pinnable = true;
    pin-with-key = true;
    pin_key = right-click;
  };

  btnConfig = color: color': {
    type = "btn";
    thickness = 15;
    length = "10%";
    color = "${color}";
    border_color = "${color'}";
    border_width = 2;
  };

  workspaceDown = position: {
    position = "${position}";
    monitor = [
      config.lib.monitors.mainMonitorName
    ] ++ config.lib.monitors.otherMonitorsNames;
    margins.${position} = "35%";
  };

  monitorDown = position: {
    position = "${position}";
    monitor = config.lib.monitors.otherMonitorsNames;
    margins.${position} = 0;
  };

  workspaceUp = position: {
    position = "${position}";
    monitor = [
      config.lib.monitors.mainMonitorName
    ] ++ config.lib.monitors.otherMonitorsNames;
    margins.${position} = "35%";
  };

  monitorUp = position: {
    position = "${position}";
    monitor = config.lib.monitors.mainMonitorName;
    margins.${position} = 0;
  };

  columnWorkspaceDown =
    commonConfig "bottom"
    // workspaceDown "left"
    // {
      widget = btnConfig "${base07}" "${base0A}" // {
        event_map = {
          ${builtins.toString left-click} = "niri msg action move-column-to-workspace-down";
        };
      };
    };
  columnMonitorDown =
    commonConfig "left"
    // monitorDown "bottom"
    // {
      widget = btnConfig "${base0E}" "${base0A}" // {
        event_map = {
          ${builtins.toString left-click} = "niri msg action move-column-to-monitor-down";
        };
      };
    };

  columnWorkspaceUp =
    commonConfig "top"
    // workspaceUp "right"
    // {
      widget = btnConfig "${base0F}" "${base0A}" // {
        event_map = {
          ${builtins.toString left-click} = "niri msg action move-column-to-workspace-up";
        };
      };
    };
  columnMonitorUp =
    commonConfig "left"
    // monitorUp "top"
    // {
      widget = btnConfig "${base08}" "${base0A}" // {
        event_map = {
          ${builtins.toString left-click} = "niri msg action move-column-to-monitor-up";
        };
      };
    };
in
[
  columnWorkspaceDown
  columnWorkspaceUp
]
++ (lib.optional (config.lib.monitors.otherMonitorsNames != [ ]) columnMonitorDown)
++ (lib.optional (config.lib.monitors.otherMonitorsNames != [ ]) columnMonitorUp)
