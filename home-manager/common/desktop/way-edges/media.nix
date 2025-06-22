{ config, isLaptop, ... }:
with config.lib.stylix.colors.withHashtag;
let
  left-click = 272;
  right-click = 273;
  middle-click = 274;
  side-click-1 = 275;
  side-click-2 = 276;

  mediaConfig = {
    namespace = "media";
    edge = "right";
    position = "bottom";
    layer = "overlay";
    monitor = config.lib.monitors.mainMonitorName;
    extra-trigger-size = 0;
    preview-size = "8%";
    animation-curve = "ease-expo";
    transition-duration = 300;
    margins.bottom = "2%";
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
    items = [
      {
        index = [
          (-1)
          (-1)
        ];
        type = "text";
        fg-color = "${base0B}";
        font-family = "${config.stylix.fonts.monospace.name}";
        font-size =
          let
            sizeParameter = if isLaptop then 5 else 12;
          in
          config.stylix.fonts.sizes.desktop + sizeParameter;
        preset = {
          type = "custom";
          cmd = "get_media_info";
          update-interval = 1000;
        };
      }
    ];
  };
in
[
  mediaConfig
]
