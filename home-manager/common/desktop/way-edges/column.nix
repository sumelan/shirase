{ config, ... }:
with config.lib.stylix.colors.withHashtag;
let
  left-click = 272;
  right-click = 273;
  middle-click = 274;
  side-click-1 = 275;
  side-click-2 = 276;

  commonConfig = {
    name = "move_column";
    edge = "left";
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

  workspaceDown = {
    position = "bottom";
    monitor = [
      config.lib.monitors.mainMonitorName
    ] ++ config.lib.monitors.otherMonitorsNames;
    margins.bottom = "10%";
  };

  monitorDown = {
    position = "bottom";
    monitor = config.lib.monitors.mainMonitorName;
    margins.bottom = 0;
  };

  workspaceUp = {
    position = "top";
    monitor = [
      config.lib.monitors.mainMonitorName
    ] ++ config.lib.monitors.otherMonitorsNames;
    margins.top = "10%";
  };

  monitorUp = {
    position = "top";
    monitor = config.lib.monitors.otherMonitorsNames;
    margins.top = 0;
  };

  columnWorkspaceDown =
    commonConfig
    // workspaceDown
    // {
      widget = btnConfig "${base07}" "${base0A}" // {
        event_map = {
          ${builtins.toString left-click} = "niri msg action move-column-to-workspace-down";
        };
      };
    };
  columnMonitorDown =
    commonConfig
    // monitorDown
    // {
      widget = btnConfig "${base0E}" "${base0A}" // {
        event_map = {
          ${builtins.toString left-click} = "niri msg action move-column-to-monitor-down";
        };
      };
    };

  columnWorkspaceUp =
    commonConfig
    // workspaceUp
    // {
      widget = btnConfig "${base0F}" "${base0A}" // {
        event_map = {
          ${builtins.toString left-click} = "niri msg action move-column-to-workspace-up";
        };
      };
    };
  columnMonitorUp =
    commonConfig
    // monitorUp
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
  columnMonitorDown
  columnWorkspaceUp
  columnMonitorUp
]
