_: {
  flake.modules.nixos."hosts/sakura" = {
    config,
    user,
    ...
  }: {
    hjem.users.${user}.rum = {
      programs.noctalia = {
        settings = {
          lockscreen_widgets = {
            enabled = true;
            schema_version = 2;
            widget_order = [
              "lockscreen-login-box@HDMI-A-1"
              "lockscreen-widget-0000000000000001"
            ];

            grid = {
              cell_size = 16;
              major_interval = 4;
              visible = true;
            };

            widget = {
              "lockscreen-login-box@HDMI-A-1" = {
                box_height = 196.0;
                box_width = 720.0;
                cx = 2080.0;
                cy = 1232.0;
                output = "HDMI-A-1";
                placement_height = 1440.0;
                placement_width = 2560.0;
                rotation = 0.0;
                type = "login_box";

                settings = {
                  background_color = "surface_variant";
                  background_opacity = 0.75;
                  background_radius = 12.0;
                  center_password_text = true;
                  input_opacity = 0.60;
                  input_radius = 6.0;
                  layout = "regular";
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
                box_height = 270.0;
                box_width = 688.0;
                cx = 2056.0;
                cy = 584.0;
                output = "HDMI-A-1";
                placement_height = 1440.0;
                placement_width = 2560.0;
                rotation = 0.0;
                type = "clock";

                settings = {
                  background = false;
                  clock_style = "digital";
                  font_family = config.custom.fonts.monospace;
                  format = "{:%H:%M}";
                };
              };
            };
          };

          desktop_widgets = {
            schema_version = 2;
            widget_order = ["desktop-widget-0000000000000001"];

            grid = {
              cell_size = 16;
              major_interval = 4;
              visible = true;
            };

            widget = {
              desktop-widget-0000000000000001 = {
                box_height = 80.00;
                box_width = 286.00;
                cx = 2400.00;
                cy = 1351.00;
                output = "HDMI-A-1";
                placement_height = 1440.0;
                placement_width = 2560.0;
                rotation = 0.0;
                type = "label";

                settings = {
                  background = false;
                  color = "tertiary";
                  font_family = config.custom.fonts.monospace;
                  opacity = 0.45000000000000000;
                  title = "󱄅 NixOS";
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
        };
      };
    };
  };
}
