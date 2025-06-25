{ config, ... }:
with config.lib.stylix.colors.withHashtag;
let
  left-click = 272;
  right-click = 273;
  middle-click = 274;
  side-click-1 = 275;
  side-click-2 = 276;

  trayConfig = {
    namespace = "tray";
    edge = "top";
    position = "right";
    layer = "overlay";
    monitor = config.lib.monitors.mainMonitorName;
    extra-trigger-size = 0;
    preview-size = "15%";
    animation-curve = "ease-expo";
    transition-duration = 300;
    margins.right = "10%";
    ignore-exclusive = true;
    pinnable = true;
    pin-with-key = true;
    pin-key = right-click;
    type = "wrap-box";
    align = "top-left";
    gap = 10;
    outlook = {
      type = "window";
      color = "${base00}";
      border-radius = 8;
      border-width = 2;
      margins = {
        left = 5;
        right = 5;
        bottom = 5;
        top = 5;
      };
    };
    items = [
      {
        index = [
          (-1)
          (-1)
        ]; # position in the grid layout. -1 means next available position.
        type = "tray";
        font-family = "${config.stylix.fonts.monospace.name}";
        grid-align = "top-left";
        icon-theme = config.stylix.iconTheme.dark;
        tray-gap = 3;
        icon-size = 26;
        header-draw-config = {
          text-color = "${base05}";
          font-pixel-height = 18;
        };
        header-menu-align = "left";
        header-menu-stack = "menu-top";
        menu-draw-config = {
          border-color = "${base02}";
          text-color = "${base05}";
          marker-color = "${base0B}";
          font-pixel-height = 18;
          icon-size = 18;
          marker-size = 15;
          separator-height = 1;
          margin = [
            # horizontal, vertical
            5
            5
          ];
        };
      }
    ];
  };
in
[
  trayConfig
]
