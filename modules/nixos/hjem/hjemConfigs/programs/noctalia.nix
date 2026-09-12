_: {
  flake.custom.hjemConfigs.noctalia = {
    config,
    user,
    ...
  }: {
    hjem.users.${user}.rum = {
      programs.noctalia = {
        enable = true;
        package = config.programs.noctalia.package;
        settings = {
          config_version = 14;

          audio = {
            enable_sounds = true;
          };

          backdrop = {
            enabled = true;
            blur_intensity = 0.2;
          };

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
              end = ["group:g2" "group:g1" "battery"];
              font_family = config.custom.fonts.monospace;
              icon_color = "hover";
              margin_ends = 0;
              position = "top";
              radius = 20;
              scale = 1.25;
              start = ["text_1" "workspaces" "tray"];
              thickness = 34;
              widget_spacing = 20;

              capsule_group = [
                {
                  accordion = false;
                  accordion_direction = "end";
                  enabled = true;
                  fill = "surface_variant";
                  id = "g1";
                  members = ["volume" "brightness"];
                  opacity = 0.5;
                  padding = 10.0;
                }
                {
                  accordion = false;
                  accordion_direction = "end";
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

          brightness = {
            enable_ddcutil = true;
            sync_all_monitors = true;
          };

          calendar = {
            enabled = true;
          };

          location = {
            auto_locate = true;
          };

          osd = {
            background_opacity = 0.60;
            position = "bottom_center";
            position_vertical = "bottom_center";
          };

          plugin_settings = {
            "noctalia/mpvpaper" = {
              picker_placement = "floating";
              picker_position = "top_left";
              video_directory = "~/Videos/Wallpapers/blueArchive";
            };
          };

          plugins = {
            enabled = ["noctalia/mpvpaper"];
          };

          shell = {
            avatar_path = "/home/sumelan/.face";
            font_family = "Montserrat";
            polkit_agent = true;
            settings_show_advanced = true;
            setup_wizard_enabled = false;

            greeter_sync = {
              auto_sync = true;
            };

            launcher = {
              categories = false;
            };

            panel = {
              shadow = false;
              clipboard_position = "bottom_center";
              control_center_placement = "attached";
              launcher_placement = "floating";
              open_near_click_control_center = true;
              session_placement = "floating";
              session_position = "bottom_center";
              transparency_mode = "glass";
              wallpaper_placement = "floating";
              wallpaper_position = "top_left";
            };

            screen_corners = {
              enabled = true;
              size = 40;
            };

            screenshot = {
              directory = "/home/sumelan/Pictures/Screenshots";
              pipe_command =
                # sh
                ''swash'';
              pipe_to_command = true;
            };
          };

          theme = {
            builtin = "Nord";
            community_palette = "Catppuccin Frappe Pink";
            mode = "dark";
            source = "community";

            templates = {
              builtin_ids = ["mango"];
              community_ids = [];
            };
          };

          wallpaper = {
            directory = "${config.hjem.users.${user}.directory}/Pictures/Wallpapers";
          };

          widget = {
            audio_visualizer = {
              color_1 = "tertiary";
              color_2 = "secondary";
              bands = 20;
              width = 200;
            };

            bluetooth = {
              font_family = config.custom.fonts.monospace;
              hide_when_no_connected_device = true;
              show_label = true;
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

            "text_1" = {
              color = "tertiary";
              font_family = config.custom.fonts.monospace;
              text = "MangoWM";
              type = "text";
              left = "panel-toggle control-center";
            };

            tray = {
              font_family = config.custom.fonts.monospace;
              hidden = ["blueman" "nm-applet" "fcitx5"];
            };

            workspaces = {
              show_labels = true;
              focused_output_only = true;
              font_family = config.custom.fonts.monospace;
              hide_when_empty = true;
              labels_only_when_occupied = true;
            };
          };
        };
      };
    };

    custom.fileSystem = {
      cache.home.directories = [
        ".cache/noctalia"
        ".local/state/noctalia"
      ];
    };
  };
}
