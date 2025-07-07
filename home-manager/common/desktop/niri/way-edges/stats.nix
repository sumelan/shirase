{ config, isLaptop, ... }:
with config.lib.stylix.colors.withHashtag;
let
  right-click = 273;

  commonConfig = {
    namespace = "stats";
    edge = "right";
    position = "bottom";
    layer = "overlay";
    monitor = config.lib.monitors.mainMonitorName;
    extra-trigger-size = 0;
    preview-size = "3%";
    animation-curve = "ease-expo";
    transition-duration = 300;
    margins.bottom = "4%";
    ignore-exclusive = true;
    pinnable = true;
    pin-with-key = true;
    pin-key = right-click;
  };

  commonWrap-box = {
    type = "wrap-box";
    align = "center-right";
    gap = 8;
    outlook = {
      type = "window";
      color = "${base01}";
      border-radius = 8;
      border-width = 2;
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
    animation-curve = "ease-expo";
    font-family = "${config.stylix.fonts.monospace.name}";
    font-size =
      let
        sizeParameter = if isLaptop then 5 else 12;
      in
      config.stylix.fonts.sizes.desktop + sizeParameter;
    prefix-hide = false;
    suffix-hide = true;
    ring-width = 6;
    radius = 16;
    text-transition-ms = 100;
  };

  cpuConfig = {
    bg-color = "${base00}";
    fg-color = "${base07}";
    prefix = " ";
    suffix = " {preset}";
    preset = {
      type = "cpu";
      update-interval = 1000;
      core = null;
    };
  };

  ramConfig = {
    bg-color = "${base00}";
    fg-color = "${base09}";
    prefix = " ";
    suffix = " {preset}";
    preset = {
      type = "ram";
      update-interval = 1000;
    };
  };

  diskConfig = {
    bg-color = "${base00}";
    fg-color = "${base0D}";
    prefix = " ";
    suffix = " {preset}";
    preset = {
      type = "disk";
      update-interval = 1000;
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

  statsConfig =
    commonConfig
    // commonWrap-box
    // {
      items = [
        cpuStats
        ramStats
        diskStats
      ];
    };
in
[
  statsConfig
]
