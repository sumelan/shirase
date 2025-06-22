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
    preview-size = "5%";
    animation-curve = "ease-expo";
    transition-duration = 300;
    ignore-exclusive = true;
    pinnable = true;
    pin-with-key = false;
    #   pin-key = right-click;
  };

  commonSlider = {
    type = "slider";
    thickness = "0.5%";
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
    bg-color = "${base01}";
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
    bg-color = "${base01}";
    bg-text-color = "${base04}";
    fg-text-color = "${base05}";
    preset = {
      type = "backlight";
      device = "intel_backlight";
    };
  };

  mediaConfig = {
    border-color = "${base03}";
    fg-color = "${base0B}";
    bg-color = "${base01}";
    bg-text-color = "${base01}00";
    fg-text-color = "${base01}00";
    preset = {
      type = "custom";
      update-interval = 1000;
      update-command = "get_media_progress";
      on-change-command = "";
      event-map = {
        ${builtins.toString left-click} = "playerctl play-pause";
        ${builtins.toString right-click} = "playerctl next";
      };
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

  mediaEdge =
    commonConfig
    // commonSlider
    // mediaConfig
    // {
      edge = "bottom";
      position = "right";
      margins.right = "35%";
    };
in
[
  # speakerEdge
  mediaEdge
]
# ++ (lib.optional config.custom.backlight.enable backlightEdge)
