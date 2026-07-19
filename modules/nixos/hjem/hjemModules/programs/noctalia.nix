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
          order = ["sideBar"];
          sideBar = {
            background_opacity = 0.5;
            capsule_opacity = 0.50;
            capsule_padding = 10.0;
            center = ["media" "audio_visualizer"];
            end = ["recorder" "network" "bluetooth" "volume" "brightness" "battery" "session"];
            font_family = "Maple Mono NF";
            icon_color = "primary";
            margin_ends = 0;
            position = "left";
            radius = 20;
            scale = 1.5;
            start = ["control-center" "workspaces" "notifications" "nix-monitor" "privacy"];
            thickness = 50;
            widget_spacing = 20;
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
          active_monitor_only = true;
          auto_hide = true;
          background_opacity = 0.35;
        };

        location = {
          auto_locate = true;
        };

        osd = {
          position = "bottom_center";
          position_vertical = "bottom_center";
        };

        plugin_settings = {
          "avivbintangaringga/nix-monitor" = {
            clean_command =
              # sh
              ''nh clean all -k 5'';
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
          font_family = "Inter Display";
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
            control_center_placement = "floating";
            control_center_position = "top_left";
            launcher_placement = "floating";
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
          mode = "dark";
          source = "builtin";

          templates = {
            builtin_ids = ["niri"];
            community_ids = [];
          };
        };

        widget = {
          audio_visualizer = {
            width = 125;
          };

          control-center = {
            font_family = "Maple Mono NF";
            glyph = "niri";
          };

          media = {
            art_size = 25;
            hide_when_no_media = true;
            title_scroll = "on_hover";
          };

          network = {
            show_label = false;
          };

          nix-monitor = {
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
