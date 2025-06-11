{ lib, config, ... }:
with config.lib.stylix.colors.withHashtag;
let
  left-click = 272;
  right-click = 273;
  middle-click = 274;
  side-click-1 = 275;
  side-click-2 = 276;

  commonConfig = {
    name = "slider";
    layer = "overlay";
    monitor = config.lib.monitors.mainMonitorName;
    extra-trigger-size = 0;
    preview-size = "30%";
    animation-curve = "ease-expo";
    transition-duration = 300;
    ignore-exclusive = false;
    pinnable = true;
    pin-with-key = true;
    pin-key = right-click;
  };

  commonSlider = {
    type = "slider";
    thickness = 20;
    length = "25%";
    border-width = 3;
    redraw-only-on-internal-update = true;
    radius = 20;
    obtuse-angle = 120;
  };

  speakerConfig = {
    border-color = "${base09}";
    fg-color = "${base0C}";
    bg-color = "${base00}";
    bg-text-color = "${base04}";
    fg-text-color = "${base05}";
    preset = {
      type = "speaker";
      device = null;
      animation-curve = "ease-expo";
      mute-text-color = "${base08}";
      mute-color = "${base00}";
    };
  };

  backlightConfig = {
    border-color = "${base09}";
    fg-color = "${base0A}";
    bg-color = "${base00}";
    bg-text-color = "${base04}";
    fg-text-color = "${base05}";
    preset = {
      type = "backlight";
      device = null;
    };
  };

  speakerEdge =
    commonConfig
    // commonSlider
    // speakerConfig
    // {
      edge = "bottom";
      position = "right";
      margins.right = "15%";
    };

  backlightEdge =
    commonConfig
    // commonSlider
    // backlightConfig
    // {
      edge = "bottom";
      position = "left";
      margins.left = "15%";
    };
in
[
  speakerEdge
]
++ (lib.optional config.custom.backlight.enable backlightEdge)
