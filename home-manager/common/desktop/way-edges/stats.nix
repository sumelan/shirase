{ lib, config, ... }:
with config.lib.stylix.colors.withHashtag;
let
  left-click = 272;
  right-click = 273;
  middle-click = 274;
  side-click-1 = 275;
  side-click-2 = 276;

  commonConfig = {
    namespace = "stats";
    edge = "right";
    position = "top";
    layer = "overlay";
    monitor = config.lib.monitors.mainMonitorName;
    extra_trigger_size = 0;
    preview_size = "38%";
    animation_curve = "ease-expo";
    transition_duration = 300;
    margins.top = "5%";
    ignore_exclusive = true;
    pinnable = true;
    pin-with-key = true;
    pin_key = right-click;
  };

  commonWrap-box = {
    type = "wrap-box";
    align = "center_right";
    gap = 8;
    outlook = {
      type = "window";
      color = "${base02}";
      border_radius = 8;
      border_width = 5;
      margins = {
        left = 5;
        right = 5;
        bottom = 5;
        top = 5;
      };
    };
  };

  commonRing = {
    type = "ring";
    animation_curve = "ease-expo";
    font_family = "Maple Mono NF";
    font_size = 20;
    prefix_hide = false;
    suffix_hide = true;
    ring_width = 8;
    radius = 20;
    text_transition_ms = 100;
  };

  batteryConfig = {
    bg_color = "${base00}";
    fg_color = "${base0B}";
    prefix = " ";
    suffix = " {preset}";
    preset = {
      type = "battery";
      update_interval = 500;
    };
  };

  cpuConfig = {
    bg_color = "${base00}";
    fg_color = "${base07}";
    prefix = " ";
    suffix = " {preset}";
    preset = {
      type = "cpu";
      update_interval = 500;
      core = null;
    };
  };

  ramConfig = {
    bg_color = "${base00}";
    fg_color = "${base09}";
    prefix = " ";
    suffix = " {preset}";
    preset = {
      type = "ram";
      update_interval = 500;
    };
  };

  diskConfig = {
    bg_color = "${base00}";
    fg_color = "${base0D}";
    prefix = " ";
    suffix = " {preset}";
    preset = {
      type = "disk";
      update_interval = 500;
      partition = "/persist";
    };
  };

  cpuStats =
    commonRing
    // cpuConfig
    // {
      index = [
        (-1)
        (-1)
      ];
    };
  ramStats =
    commonRing
    // ramConfig
    // {
      index = [
        (-1)
        (-1)
      ];
    };
  diskStats =
    commonRing
    // diskConfig
    // {
      index = [
        (-1)
        (-1)
      ];
    };
  batteryStats =
    commonRing
    // batteryConfig
    // {
      index = [
        (-1)
        (-1)
      ];
    };

  statsConfig =
    commonConfig
    // commonWrap-box
    // {
      items = [
        cpuStats
        ramStats
        diskStats
      ]
      # ++ (lib.optional config.custom.battery.enable batteryStats)
      ;
    };
in
[
  statsConfig
]
