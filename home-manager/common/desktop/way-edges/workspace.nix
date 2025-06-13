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
    monitor = [
      config.lib.monitors.mainMonitorName
    ] ++ config.lib.monitors.otherMonitorsNames;
    animation-curve = "ease-expo";
    transition-duration = 300;
    ignore-exclusive = false;
    pinnable = true;
    pin-with-key = true;
    pin-key = right-click;
  };

  workspaceTransition =
    direction: color: action:
    commonConfiguration
    // {
      namespace = "focus-workspace-${direction}";
      edge = "left";
      position = "${direction}";
      extra-trigger-size = 0;
      preview-size = "20%";
      margins.${direction} = "5%";
      type = "btn";
      thickness = 15;
      length = "6%";
      color = "${color}";
      border-width = 2;
      border-color = "${base05}";
      event-map = {
        ${builtins.toString left-click} = "niri msg action ${action}";
      };
    };

  workspaceIndicator = commonConfiguration // {
    namespace = "workspace-indicator";
    edge = "left";
    position = "top";
    extra-trigger-size = 0;
    preview-size = "10%";
    margins.top = "55%";
    type = "workspace";
    thickness = 20;
    length = "25%";
    active-increase = 0.3;
    active-color = "${base0E}"; # second monitor color
    default-color = "${base00}";
    focus-color = "${base09}";
    hover-color = "${base05}80";
    gap = 5;
    invert-direction = false;
    pop-duration = 500;
    workspace-transition_duration = 300;
    focused-only = false;
    preset = {
      type = "niri";
      filter-empty = false;
    };
  };
in
[
  (workspaceTransition "top" "${base0D}" "focus-window-or-workspace-up")
  (workspaceTransition "bottom" "${base0E}" "focus-window-or-workspace-down")
  workspaceIndicator
]
