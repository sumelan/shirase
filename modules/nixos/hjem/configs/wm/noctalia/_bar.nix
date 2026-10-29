{config}: {
  bar = {
    order = ["topBar" "bottomBar"];

    bottomBar = {
      shadow = false;
      contact_shadow = false;
      background_opacity = 0.5;
      center = ["privacy"];
      enabled = true;
      end = ["audio_visualizer" "media"];
      font_family = config.custom.fonts.monospace;
      icon_color = "secondary";
      margin_ends = 0;
      position = "bottom";
      radius = 20;
      scale = 1.25;
      start = ["cpu" "ram"];
    };

    topBar = {
      shadow = false;
      contact_shadow = false;
      background_opacity = 0.5;
      capsule_opacity = 0.50;
      capsule_padding = 10.0;
      center = ["nightlight" "clock" "caffeine"];
      end = ["group:g2" "group:g1"];
      font_family = config.custom.fonts.monospace;
      icon_color = "hover";
      margin_ends = 0;
      position = "top";
      radius = 20;
      scale = 1.25;
      start = ["control-center" "workspaces" "tray"];
      thickness = 34;
      widget_spacing = 20;

      capsule_group = [
        {
          accordion = false;
          accordion_direction = "end";
          border_width = 1.0;
          enabled = true;
          fill = "surface_variant";
          id = "g1";
          members = ["volume" "brightness" "battery"];
          opacity = 0.5;
          padding = 10.0;
        }
        {
          accordion = false;
          accordion_direction = "end";
          border_width = 1.0;
          enabled = true;
          fill = "surface_variant";
          id = "g2";
          members = ["notifications" "network" "bluetooth"];
          opacity = 0.5;
          padding = 10.0;
        }
      ];
    };
  };
}
