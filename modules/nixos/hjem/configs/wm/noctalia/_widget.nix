{config}: {
  widget = {
    audio_visualizer = {
      color_1 = "tertiary";
      color_2 = "secondary";
      bands = 15;
      width = 120;
    };

    battery = {
      icon_color = "primary";
    };

    bluetooth = {
      font_family = config.custom.fonts.monospace;
      icon_color = "tertiary";
      hide_when_no_connected_device = true;
      show_label = true;
    };

    brightness = {
      icon_color = "primary";
    };

    caffeine = {
      font_family = config.custom.fonts.monospace;
      icon_color = "secondary";
    };

    clock = {
      format = "{:%H:%M}";
      font_family = config.custom.fonts.monospace;
      font_weight = 700;
      tooltip_format = "{:%c}";
    };

    control-center = {
      glyph = "niri";
      icon_color = "secondary";
      font_family = config.custom.fonts.monospace;
    };

    media = {
      art_size = 25;
      font_family = config.custom.fonts.monospace;
      hide_when_no_media = true;
      max_length = 300;
      title_scroll = "on_hover";
    };

    network = {
      font_family = config.custom.fonts.monospace;
      icon_color = "tertiary";
      show_label = true;
      show_vpn_label = true;
    };

    nightlight = {
      font_family = config.custom.fonts.monospace;
      icon_color = "secondary";
    };

    notifications = {
      hide_when_no_unread = true;
      icon_color = "secondary";
    };

    recorder = {
      icon_color = "primary";
      type = "noctalia/screen_recorder:recorder";
    };

    tray = {
      font_family = config.custom.fonts.monospace;
      icon_color = "tertiary";
      hidden = ["blueman" "nm-applet" "fcitx5"];
    };

    volume = {
      icon_color = "primary";
    };

    workspaces = {
      show_labels = false;
      focused_output_only = true;
      font_family = config.custom.fonts.monospace;
      hide_when_empty = true;
      labels_only_when_occupied = true;
    };
  };
}
