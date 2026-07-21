{inputs, ...}: {
  flake.custom.hjemModules.noctalia = {pkgs, ...}: let
    waytator = inputs.waytator.packages.${pkgs.stdenv.hostPlatform.system}.default;
  in {
    imports = [inputs.noctalia.hjemModules.default];

    packages = builtins.attrValues {
      inherit (pkgs) ddcutil mpvpaper gpu-screen-recorder;
      inherit waytator;
    };

    programs.noctalia = {
      enable = true;
      systemd.enable = true;

      settings = {
        config_version = 2;

        audio = {
          enable_sounds = true;
        };

        backdrop = {
          enabled = true;
          blur_intensity = 0.2;
        };

        bar = {
          order = ["topBar"];

          topBar = {
            background_opacity = 0.5;
            capsule_opacity = 0.50;
            capsule_padding = 10.0;
            center = ["clock"];
            end = ["group:g2" "group:g1" "nix_monitor" "battery"];
            font_family = "Maple Mono NF";
            icon_color = "primary";
            margin_ends = 0;
            position = "top";
            radius = 20;
            scale = 1.5;
            start = ["control-center" "workspaces" "group:g3"];
            thickness = 40;
            widget_spacing = 20;

            capsule_group = [
              {
                enabled = true;
                fill = "surface_variant";
                id = "g1";
                members = ["volume" "brightness"];
                opacity = 0.5;
                padding = 10.0;
              }
              {
                enabled = true;
                fill = "surface_variant";
                id = "g2";
                members = ["notifications" "network" "bluetooth"];
                opacity = 0.5;
                padding = 10.0;
              }
              {
                enabled = true;
                fill = "surface_variant";
                id = "g3";
                members = ["media" "audio_visualizer"];
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

        dock = {
          background_opacity = 0.45;
          enabled = true;
          pinned = [
            "org.gnome.Nautilus"
            "proton-mail"
            "com.github.th-ch.youtube-music"
            "vesktop"
            "helium"
            "Helix"
            "typora"
            "com.mitchellh.ghostty"
          ];
          position = "bottom";
          reserve_space = true;
          show_dots = true;
          show_instance_count = false;
          show_running = false;
          smart_auto_hide = false;
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
          "avivbintangaringga/nix-monitor" = {
            clean_command =
              # sh
              ''nh clean all'';
            panel_position = "auto";
            show_update_available_notification = false;
            update_command =
              # sh
              ''tack update && nh os switch'';
          };

          "noctalia/mpvpaper" = {
            picker_placement = "floating";
            picker_position = "top_left";
            video_directory = "~/Videos/Wallpapers/blueArchive";
          };
        };

        plugins = {
          enabled = ["noctalia/notes" "noctalia/mpvpaper" "noctalia/screen_recorder" "avivbintangaringga/nix-monitor"];
        };

        shell = {
          avatar_path = "/home/sumelan/.face";
          font_family = "Noto Sans CJK JP";
          niri_overview_type_to_launch_enabled = true;
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
              ''waytator'';
            pipe_to_command = true;
          };
        };

        theme = {
          builtin = "Nord";
          community_palette = "Nord Aurora";
          mode = "dark";
          source = "community";

          templates = {
            builtin_ids = ["niri"];
            community_ids = [];
          };
        };

        widget = {
          audio_visualizer = {
            color_1 = "secondary";
            color_2 = "tertiary";
            width = 150;
          };

          bluetooth = {
            font_family = "Maple Mono NF";
            hide_when_no_connected_device = true;
            show_label = true;
          };

          clock = {
            format = " {:%H:%M}";
            tooltip_format = "{:%c}";
          };

          control-center = {
            font_family = "Maple Mono NF";
            glyph = "niri";
          };

          media = {
            art_size = 25;
            font_family = "Maple Mono NF";
            hide_when_no_media = true;
            max_length = 150;
            title_scroll = "on_hover";
          };

          network = {
            font_family = "Maple Mono NF";
            show_label = true;
            show_vpn_label = true;
          };

          nix_monitor = {
            font_family = "Maple Mono NF";
            show_text = false;
            type = "avivbintangaringga/nix-monitor:nix-monitor";
          };

          recorder = {
            type = "noctalia/screen_recorder:recorder";
          };

          workspaces = {
            display = "none";
            focused_output_only = true;
            font_family = "Maple Mono NF";
            hide_when_empty = true;
            labels_only_when_occupied = true;
          };
        };
      };
    };
  };
}
