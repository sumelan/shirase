_: {
  hjem.users.sumelan.rum = {
    programs.noctalia = {
      settings = {
        idle = {
          behavior_order = ["lock" "screen-off" "lock-and-suspend"];

          behavior = {
            lock = {
              action = "lock";
              enabled = true;
              timeout = 480.0;
            };

            lock-and-suspend = {
              action = "lock_and_suspend";
              enabled = false;
              timeout = 900.0;
            };

            screen-off = {
              action = "screen_off";
              enabled = true;
              timeout = 600.0;
            };
          };
        };

        lockscreen_widgets = {
          enabled = true;
          schema_version = 2;
          widget_order = ["lockscreen-login-box@DP-1" "lockscreen-widget-0000000000000001" "lockscreen-widget-0000000000000002"];

          grid = {
            cell_size = 16;
            major_interval = 4;
            visible = true;
          };

          widget = {
            "lockscreen-login-box@DP-1" = {
              box_height = 82.0;
              box_width = 720.0;
              cx = 2157.0;
              cy = 1328.0;
              output = "DP-1";
              placement_height = 1440.0;
              placement_width = 2560.0;
              rotation = 0.0;
              type = "login_box";

              settings = {
                background_color = "surface_variant";
                background_opacity = 0.88;
                background_radius = 22.0;
                center_password_text = true;
                input_opacity = 0.60;
                input_radius = 6.0;
                layout = "regular";
                show_caps_lock = true;
                show_keyboard_layout = true;
                show_login_button = true;
                show_media = false;
                show_password_reveal = true;
                show_session_buttons = false;
                show_unlock_hint = true;
                show_weather = false;
              };
            };

            "lockscreen-widget-0000000000000001" = {
              box_height = 368.0;
              box_width = 192.0;
              cx = 1904.0;
              cy = 997.0;
              output = "DP-1";
              placement_height = 1440.0;
              placement_width = 2560.0;
              rotation = 0.0;
              type = "clock";

              settings = {
                background = true;
                background_opacity = 0.60;
                background_padding = 0;
                background_radius = 32;
                circle = true;
                clock_style = "analog";
                color = "secondary";
                show_seconds = true;
              };
            };

            "lockscreen-widget-0000000000000002" = {
              box_height = 368.0;
              box_width = 496.0;
              cx = 2256.0;
              cy = 997.0;
              output = "DP-1";
              placement_height = 1440.0;
              placement_width = 2560.0;
              rotation = 0.0;
              type = "calendar";
            };
          };
        };
      };
    };
  };
}
