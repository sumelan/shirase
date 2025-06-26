{ config, ... }:
with config.lib.stylix.colors.withHashtag;
let
  right-click = 273;

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

  workspaceIndicator = commonConfiguration // {
    namespace = "workspace";
    edge = "left";
    position = "top";
    extra-trigger-size = 0;
    preview-size = "12%";
    margins.top = "35%";
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
  workspaceIndicator
]
