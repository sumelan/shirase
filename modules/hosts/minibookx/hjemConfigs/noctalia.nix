_: {
  flake.modules.nixos."hosts/minibookx" = {
    config,
    user,
    ...
  }: {
    hjem.users.${user}.rum = {
      programs.noctalia = {
        settings = {
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
                box_height = 64.0;
                box_width = 240.0;
                cx = 1784.0;
                cy = 1112.0;
                output = "DSI-1";
                placement_height = 1200.0;
                placement_width = 1920.0;

                rotation = 0.0;
                type = "label";

                settings = {
                  background = false;
                  background_opacity = 0.6;
                  color = "hover";
                  description = "";
                  font_family = config.custom.fonts.monospace;
                  opacity = 0.45;
                  shadow = true;
                  title = " NixOS";
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
                timeout = 400.0;
              };
              lock-and-suspend = {
                action = "lock_and_suspend";
                enabled = true;
                timeout = 800.0;
              };

              screen-off = {
                action = "screen_off";
                enabled = true;
                timeout = 500.0;
              };
            };
          };

          lockscreen_widgets = {
            enabled = true;
            schema_version = 2;
            widget_order = [
              "lockscreen-login-box@DSI-1"
              "lockscreen-widget-0000000000000001"
            ];

            grid = {
              cell_size = 16;
              major_interval = 4;
              visible = true;
            };

            widget = {
              "lockscreen-login-box@DSI-1" = {
                box_height = 70.0;
                box_width = 400.0;
                cx = 1584.0;
                cy = 1061.0;
                output = "DSI-1";
                placement_height = 1200.0;
                placement_width = 1920.0;

                rotation = 0.0;
                type = "login_box";

                settings = {
                  background_color = "on_tertiary";
                  background_opacity = 0.75;
                  background_radius = 12.0;
                  center_password_text = false;
                  input_opacity = 1.0;
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
                box_height = 160.0;
                box_width = 384.0;
                cx = 1584.0;
                cy = 680.0;
                output = "DSI-1";
                placement_height = 1200.0;
                placement_width = 1920.0;
                rotation = 0.0;
                type = "clock";

                settings = {
                  background = false;
                  center_text = true;
                  color = "primary";
                  font_family = config.custom.fonts.monospace;
                  format = "{:%H:%M}";
                };
              };
            };
          };
        };
      };
    };
  };
}
