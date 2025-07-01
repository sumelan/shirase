{
  lib,
  config,
  isLaptop,
  ...
}:
with config.lib.stylix.colors.withHashtag;
let
  right-click = 273;

  commonConfig = edge: position: margin: {
    namespace = "info";
    inherit edge position;
    layer = "overlay";
    monitor = config.lib.monitors.mainMonitorName;
    extra-trigger-size = 0;
    preview-size = "10%";
    animation-curve = "ease-expo";
    transition-duration = 300;
    margins.${position} = margin;
    ignore-exclusive = true;
    pinnable = true;
    pin-with-key = true;
    pin-key = right-click;
    type = "wrap-box";
    align = "center-right";
    gap = 10;
    outlook = {
      type = "window";
      color = "${base01}";
      border-radius = 8;
      border-width = 2;
      margins = {
        left = 10;
        right = 10;
        bottom = 10;
        top = 10;
      };
    };
  };

  textConfig = color: cmd: {
    index = [
      (-1)
      (-1)
    ];
    type = "text";
    fg-color = color;
    font-family = "${config.stylix.fonts.monospace.name}";
    font-size =
      let
        sizeParameter = if isLaptop then 5 else 12;
      in
      config.stylix.fonts.sizes.desktop + sizeParameter;
    preset = {
      type = "custom";
      inherit cmd;
      update-interval = 1000;
    };
  };

  mediaEdge = commonConfig "right" "bottom" 0 // {
    items = [
      (textConfig "${base0B}" "write_media_info")
    ];
  };

  recorderEdge = commonConfig "right" "top" "6%" // {
    items = [
      (textConfig "${base08}" "write_recorder_state")
    ];
  };

  batteryEdge = commonConfig "right" "top" "2%" // {
    items = [
      (textConfig "${base0C}" "write_battery_info")
    ];
  };
in
[
  mediaEdge
  recorderEdge
]
++ (lib.optional config.custom.battery.enable batteryEdge)
