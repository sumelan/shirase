{ lib, config, ... }:
with config.lib.stylix.colors.withHashtag;
let
  left-click = 272;
  right-click = 273;
  middle-click = 274;
  side-click-1 = 275;
  side-click-2 = 276;

  commonConfig = {
    namespace = "slider";
    layer = "overlay";
    monitor = config.lib.monitors.mainMonitorName;
    extra-trigger-size = 0;
    preview-size = "28%";
    animation-curve = "ease-expo";
    transition-duration = 300;
    ignore-exclusive = true;
    pinnable = true;
    pin-with-key = true;
    pin-key = right-click;
  };

  commonSlider = {
    type = "slider";
    thickness = 20;
    length = "30%";
    border-width = 2;
    redraw-only-on-internal-update = true; # this is when you want to reduce the cpu usage
    radius = 20;
    obtuse-angle = 120; # in degrees(90~180). controls how much curve the widget has
    scroll-unit = 0.005;
  };

  speakerConfig = {
    border-color = "${base05}";
    fg-color = "${base0B}";
    bg-color = "${base00}";
    bg-text-color = "${base04}";
    fg-text-color = "${base05}";
    preset = {
      type = "speaker";
      device = null;
      animation-curve = "ease-expo";
      mute-text-color = "${base00}";
      mute-color = "${base00}";
    };
  };

  backlightConfig = {
    border-color = "${base05}";
    fg-color = "${base0A}";
    bg-color = "${base00}";
    bg-text-color = "${base04}";
    fg-text-color = "${base05}";
    preset = {
      type = "backlight";
      device = "intel_backlight";
    };
  };

  speakerEdge =
    commonConfig
    // commonSlider
    // speakerConfig
    // {
      edge = "top";
      position = "right";
      margins.right = "35%";
    };

  backlightEdge =
    commonConfig
    // commonSlider
    // backlightConfig
    // {
      edge = "bottom";
      position = "right";
      margins.right = "35%";
    };
in
[
  speakerEdge
]
++ (lib.optional config.custom.backlight.enable backlightEdge)
