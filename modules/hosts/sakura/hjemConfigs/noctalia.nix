_: {
  flake.modules.nixos."hosts/sakura" = {
    config,
    user,
    ...
  }: {
    hjem.users.${user} = {
      programs.noctalia = {
        settings = {
          lockscreen = {
            blur_intensity = 0.10;
          };

          lockscreen_widgets = {
            enabled = true;
            schema_version = 2;
            widget_order = [
              "lockscreen-login-box@HDMI-A-1"
              "lockscreen-widget-0000000000000001"
              "lockscreen-widget-0000000000000002"
            ];

            grid = {
              cell_size = 16;
              major_interval = 4;
              visible = true;
            };

            widget = {
              "lockscreen-login-box@HDMI-A-1" = {
                box_height = 70.0;
                box_width = 432.0;
                cx = 1592.0;
                cy = 895.0;
                output = "HDMI-A-1";
                placement_height = 1080.0;
                placement_width = 1920.0;
                rotation = 0.0;
                type = "login_box";

                settings = {
                  background_color = "surface_variant";
                  background_opacity = 0.75;
                  background_radius = 12.0;
                  center_password_text = true;
                  input_opacity = 0.60;
                  input_radius = 6.0;
                  layout = "compact";
                  show_caps_lock = true;
                  show_keyboard_layout = true;
                  show_login_button = true;
                  show_media = true;
                  show_session_buttons = true;
                  show_unlock_hint = true;
                  show_weather = true;
                };
              };

              lockscreen-widget-0000000000000001 = {
                box_height = 64.0;
                box_width = 384.0;
                cx = 1592.0;
                cy = 572.0;
                output = "HDMI-A-1";
                placement_height = 1080.0;
                placement_width = 1920.0;
                rotation = 0.0;
                type = "clock";

                settings = {
                  background = false;
                  clock_style = "digital";
                  font_family = config.custom.fonts.monospace;
                  format = "{:%H:%M}";
                };
              };

              lockscreen-widget-0000000000000002 = {
                box_height = 128.0;
                box_width = 624.0;
                cx = 1176.0;
                cy = 364.0;
                output = "HDMI-A-1";
                placement_height = 1080.0;
                placement_width = 1920.0;
                rotation = 0.0;
                type = "audio_visualizer";

                settings = {
                  background = false;
                  bands = 32;
                  centered = false;
                  color_1 = "hover";
                  color_2 = "on_surface";
                  mirrored = true;
                  reversed = false;
                  show_when_idle = true;
                };
              };
            };
          };

          idle = {
            behavior_order = ["lock" "screen-off" "lock-and-suspend"];

            behavior = {
              lock = {
                action = "lock";
                enabled = true;
                timeout = 600.0;
              };

              lock-and-suspend = {
                action = "lock_and_suspend";
                enabled = false;
                timeout = 900.0;
              };

              screen-off = {
                action = "screen_off";
                enabled = true;
                timeout = 900.0;
              };
            };
          };
        };
      };
    };
  };
}
