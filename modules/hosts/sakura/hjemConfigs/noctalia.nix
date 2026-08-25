_: {
  flake.modules.nixos."hosts/sakura" = {user, ...}: {
    hjem.users.${user} = {
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
                box_height = 80.0;
                box_width = 256.0;
                cx = 2416.0;
                cy = 1352.0;
                output = "DP-1";
                placement_height = 1440.0;
                placement_width = 2560.0;
                rotation = 0.0;
                type = "label";

                settings = {
                  background = false;
                  color = "on_surface";
                  description = "";
                  font_family = "Maple Mono NF";
                  opacity = 0.5;
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

          lockscreen = {
            blur_intensity = 0.0;
          };

          lockscreen_widgets = {
            enabled = true;
            schema_version = 2;
            widget_order = [
              "lockscreen-login-box@DP-1"
              "lockscreen-widget-0000000000000001"
              "lockscreen-widget-0000000000000002"
            ];

            grid = {
              cell_size = 16;
              major_interval = 4;
              visible = true;
            };

            widget = {
              "lockscreen-login-box@DP-1" = {
                box_height = 196.0;
                box_width = 832.0;
                cx = 1568.0;
                cy = 1186.0;
                output = "DP-1";
                placement_height = 1440.0;
                placement_width = 2560.0;
                rotation = 0.0;
                type = "login_box";

                settings = {
                  background_color = "surface_variant";
                  background_opacity = 0.80;
                  background_radius = 15.0;
                  center_password_text = true;
                  input_opacity = 0.31;
                  input_radius = 15.0;
                  layout = "regular";
                  show_caps_lock = true;
                  show_keyboard_layout = true;
                  show_login_button = true;
                  show_media = true;
                  show_session_buttons = true;
                  show_unlock_hint = false;
                  show_weather = true;
                };
              };

              "lockscreen-widget-0000000000000001" = {
                box_height = 144.0;
                box_width = 384.0;
                cx = 928.0;
                cy = 504.0;
                output = "DP-1";
                placement_height = 1440.0;
                placement_width = 2560.0;
                rotation = 0.0;
                type = "clock";

                settings = {
                  background = false;
                  color = "on_surface";
                  font_family = "Maple Mono NF";
                  format = "{:%H:%M}";
                };
              };

              "lockscreen-widget-0000000000000002" = {
                box_height = 144.0;
                box_width = 832.0;
                cx = 1560.0;
                cy = 576.0;
                output = "DP-1";
                placement_height = 1440.0;
                placement_width = 2560.0;
                rotation = 0.0;
                type = "audio_visualizer";

                settings = {
                  background = false;
                  bands = 32;
                  color_1 = "secondary";
                  color_2 = "tertiary";
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
