{
  lib,
  config,
  ...
}:
with config.lib.stylix.colors.withHashtag;
let
  left-click = 272;
  right-click = 273;

  commonConfig = preview: {
    namespace = "progress";
    layer = "overlay";
    monitor = config.lib.monitors.mainMonitorName;
    extra-trigger-size = 0;
    preview-size = preview;
    animation-curve = "ease-expo";
    transition-duration = 300;
    ignore-exclusive = true;
    pinnable = true;
    pin-with-key = true;
    pin-key = right-click;
  };

  commonSlider = length: thickness: {
    type = "slider";
    inherit length thickness;
    border-width = 2;
    redraw-only-on-internal-update = true; # this is when you want to reduce the cpu usage
    radius = 5;
    obtuse-angle = 90; # in degrees(90~180). controls how much curve the widget has
    scroll-unit = 0.005;
  };

  mediaConfig = {
    border-color = "${base03}";
    fg-color = "${base0B}";
    bg-color = "${base01}";
    bg-text-color = "${base01}00"; # hide text
    fg-text-color = "${base01}00"; # hide text
    preset = {
      type = "custom";
      update-interval = 500;
      update-command = "show_media_progress";
      on-change-command = "";
      event-map = {
        ${builtins.toString left-click} = "playerctl play-pause";
      };
    };
  };

  batteryConfig = {
    border-color = "${base03}";
    fg-color = "${base0B}";
    bg-color = "${base01}";
    bg-text-color = "${base04}";
    fg-text-color = "${base02}";
    preset = {
      type = "custom";
      update-interval = 1000;
      update-command = "show_battery_progress";
      on-change-command = "";
      event-map = {
        ${builtins.toString left-click} = "fuzzel-power";
      };
    };
  };

  mediaEdge =
    commonConfig "6%"
    // commonSlider "30%" "0.6%"
    // mediaConfig
    // {
      edge = "bottom";
      position = "right";
      margins.right = "36%";
    };

  batteryEdge =
    commonConfig "25%"
    // commonSlider "12%" "1.4%"
    // batteryConfig
    // {
      edge = "top";
      position = "right";
      margins.right = 0;
    };
in
[
  mediaEdge
]
++ (lib.optional config.custom.battery.enable batteryEdge)
