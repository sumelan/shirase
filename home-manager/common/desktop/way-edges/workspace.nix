{ config, ... }:
with config.lib.stylix.colors.withHashtag;
let
  left-click = 272;
  right-click = 273;
  middle-click = 274;
  side-click-1 = 275;
  side-click-2 = 276;

  commonConfiguration = {
    layer = "overlay";
    monitor = config.lib.monitors.mainMonitorName;
    animation_curve = "ease-expo";
    transition_duration = 300;
    ignore_exclusive = false;
    pinnable = true;
    pin-with-key = true;
    pin_key = right-click;
  };

  workspaceTransition =
    direction: color: action:
    commonConfiguration
    // {
      name = "focus-workspace-${direction}";
      edge = "left";
      position = "${direction}";
      extra_trigger_size = 0;
      preview_size = "20%";
      margins.${direction} = "15%";
      widget = {
        type = "btn";
        thickness = 15;
        length = "20%";
        color = "${color}";
        border_width = 2;
        border_color = "${base09}";
        event_map = {
          ${builtins.toString left-click} = "niri msg action ${action}";
        };
      };
    };

  workspaceIndicator = commonConfiguration // {
    name = "workspaces";
    edge = "left";
    position = "top";
    extra_trigger_size = 0;
    preview_size = "10%";
    margins.top = "40%";
    widget = {
      type = "workspace";
      thickness = 20;
      length = "20%";
      active_increase = 0.3;
      active_color = "${base0E}";
      default_color = "${base00}";
      focus_color = "${base0B}90";
      hover_color = "${base0B}80";
      gap = 5;
      invert_direction = false;
      pop_duration = 500;
      workspace_transition_duration = 300;
      focused_only = false;
      preset = {
        type = "niri";
        filter_empty = true;
      };
    };
  };
in
[
  (workspaceTransition "top" "${base0D}" "focus-window-or-workspace-up")
  (workspaceTransition "bottom" "${base0E}" "focus-window-or-workspace-down")
  workspaceIndicator
]
