{ config, ... }:
with config.lib.stylix.colors.withHashtag;
let
  left-click = 272;
  right-click = 273;
  middle-click = 274;
  side-click-1 = 275;
  side-click-2 = 276;

  trayConfig = {
    name = "tray";
    edge = "top";
    position = "right";
    layer = "overlay";
    monitor = config.lib.monitors.mainMonitorName;
    extra_trigger_size = 0;
    preview_size = "15%";
    animation_curve = "ease-expo";
    transition_duration = 300;
    margins.right = "10%";
    ignore_exclusive = false;
    pinnable = true;
    pin-with-key = true;
    pin_key = right-click;
    widget = {
      type = "wrap-box";
      align = "top_left";
      gap = 10;
      outlook = {
        type = "window";
        color = "${base00}";
        border_radius = 5;
        border_width = 8;
        margins = {
          left = 5;
          right = 5;
          bottom = 5;
          top = 5;
        };
      };
      widgets = [
        {
          index = [
            (-1)
            (-1)
          ]; # position in the grid layout. -1 means next available position.
          widget = {
            type = "tray";
            font_family = "monospace";
            grid_align = "center_left";
            icon_theme = config.stylix.iconTheme.dark;
            tray_gap = 2;
            icon_size = 28;
            header_draw_config = {
              text_color = "${base05}";
              font_pixel_height = 18;
            };
            header_menu_align = "left";
            header_menu_stack = "menu_top";
            menu_draw_config = {
              border_color = "${base09}";
              text_color = "${base05}";
              marker_color = "${base08}";
              font_pixel_height = 18;
              icon_size = 28;
              marker_size = 20;
              separator_height = 5;
              margin = [
                5
                5
              ];
            };
          };
        }
      ];
    };
  };
in
[
  trayConfig
]
