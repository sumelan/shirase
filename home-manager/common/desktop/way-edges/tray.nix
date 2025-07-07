{ config, ... }:
with config.lib.stylix.colors.withHashtag;
let
  right-click = 273;

  trayConfig = {
    namespace = "tray";
    edge = "left";
    position = "top";
    layer = "overlay";
    monitor = config.lib.monitors.mainMonitorName;
    extra-trigger-size = 0;
    preview-size = "10%";
    animation-curve = "ease-expo";
    transition-duration = 300;
    margins.top = 0;
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
        icon-size = 30;
        header-draw-config = {
          text-color = "${base05}";
          font-pixel-height = 30;
        };
        header-menu-align = "left";
        header-menu-stack = "menu-top";
        menu-draw-config = {
          border-color = "${base02}";
          text-color = "${base05}";
          marker-color = "${base0B}";
          font-pixel-height = 20;
          icon-size = 20;
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
