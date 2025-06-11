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
    extra_trigger_size = 0;
    preview_size = "30%";
    animation_curve = "ease-expo";
    transition_duration = 300;
    ignore_exclusive = false;
    pinnable = true;
    pin-with-key = true;
    pin_key = right-click;
  };

  commonSlider = {
    type = "slider";
    thickness = 20;
    length = "25%";
    border_width = 3;
    redraw_only_on_internal_update = true;
    radius = 20;
    obtuse_angle = 120;
  };

  speakerConfig = {
    border_color = "${base09}";
    fg_color = "${base0C}";
    bg_color = "${base00}";
    bg_text_color = "${base04}";
    fg_text_color = "${base05}";
    preset = {
      type = "speaker";
      device = null;
      animation_curve = "ease-expo";
      mute_text_color = "${base08}";
      mute_color = "${base00}";
    };
  };

  backlightConfig = {
    border_color = "${base09}";
    fg_color = "${base0A}";
    bg_color = "${base00}";
    bg_text_color = "${base04}";
    fg_text_color = "${base05}";
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
