_: {
  flake.modules.nixos."hosts/sakura" = {user, ...}: {
    hjem.users.${user} = {
      programs.noctalia = {
        settings = {
          desktop_widgets = {
            schema_version = 2;
            widget_order = ["desktop-widget-0000000000000001" "desktop-widget-0000000000000002"];

            grid = {
              cell_size = 16;
              major_interval = 4;
              visible = true;
            };

            widget = {
              desktop-widget-0000000000000001 = {
                box_height = 80.0;
                box_width = 240.0;
                cx = 2400.0;
                cy = 1368.0;
                output = "HDMI-A-2";
                rotation = 0.0;
                type = "label";

                settings = {
                  background = false;
                  background_opacity = 0.6;
                  color = "hover";
                  description = "";
                  font_family = "Maple Mono NF";
                  opacity = 0.5;
                  shadow = true;
                  title = " NixOS";
                };
              };

              desktop-widget-0000000000000002 = {
                box_height = 80.0;
                box_width = 352.0;
                cx = 256.0;
                cy = 72.0;
                output = "HDMI-A-2";
                rotation = 0.0;
                type = "clock";

                settings = {
                  background = false;
                  center_text = true;
                  color = "tertiary";
                  font_family = "Maple Mono NF";
                  format = "{:%H:%M:%S}";
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
                timeout = 720.0;
              };
            };
          };

          lockscreen_widgets = {
            enabled = true;
            schema_version = 2;
            widget_order = [
              "lockscreen-login-box@HDMI-A-2"
              "lockscreen-widget-0000000000000001"
              "lockscreen-widget-0000000000000002"
              "lockscreen-widget-0000000000000003"
            ];

            grid = {
              cell_size = 16;
              major_interval = 4;
              visible = true;
            };

            widget = {
              "lockscreen-login-box@HDMI-A-2" = {
                box_height = 70.0;
                box_width = 400.0;
                cx = 1280.0;
                cy = 1321.0;
                output = "HDMI-A-2";
                rotation = 0.0;
                type = "login_box";

                settings = {
                  background_color = "surface_variant";
                  background_opacity = 0.65;
                  background_radius = 12.0;
                  center_password_text = false;
                  input_opacity = 1.0;
                  input_radius = 6.0;
                  show_caps_lock = true;
                  show_keyboard_layout = true;
                  show_login_button = true;
                  show_password_hint = true;
                };
              };

              lockscreen-widget-0000000000000001 = {
                box_height = 352.0;
                box_width = 704.0;
                cx = 1280.0;
                cy = 528.0;
                output = "HDMI-A-2";
                rotation = 0.0;
                type = "clock";

                settings = {
                  background = false;
                  center_text = true;
                  color = "secondary";
                  font_family = "Maple Mono NF";
                  format = "{:%H:%M:%S}";
                };
              };

              lockscreen-widget-0000000000000002 = {
                box_height = 112.0;
                box_width = 480.0;
                cx = 1280.0;
                cy = 1032.0;
                output = "HDMI-A-2";
                rotation = 0.0;
                type = "media_player";

                settings = {
                  background = true;
                  background_opacity = 0.25;
                  color = "tertiary";
                  font_family = "Maple Mono NF";
                  hide_when_no_media = false;
                  shadow = true;
                };
              };

              lockscreen-widget-0000000000000003 = {
                box_height = 160.0;
                box_width = 608.0;
                cx = 1280.0;
                cy = 1184.0;
                output = "HDMI-A-2";
                rotation = 0.0;
                type = "audio_visualizer";

                settings = {
                  background = false;
                  background_color = "surface";
                  background_opacity = 0.3;
                  background_padding = 10;
                  background_radius = 12;
                  bands = 32;
                  color_1 = "tertiary";
                  color_2 = "secondary";
                  show_when_idle = true;
                };
              };
            };
          };
        };
      };
    };
  };
}
