{inputs, ...}: {
  flake.custom.hjemConfigs.sonora = {
    config,
    pkgs,
    user,
    ...
  }: let
    sonoraPkg = inputs.sonora.packages.${pkgs.stdenv.hostPlatform.system}.sonora;
  in {
    hjem.users.${user} = {
      packages = [sonoraPkg];

      xdg.config.files."sonora/settings.json" = {
        text = builtins.toJSON ({
            version = 1.0;
          }
          // {
            adaptive_menu = false;
            appearance = {
              adaptive_theme = true;
              ambient = true;
              ambient_motion = true;
              battery_saver = "off";
              blur = true;
              blur_window = true;
              controls_on_left = false;
              font_size = 14;
              fullscreen_controls_autohide = "automatic";
              icons = "lucide";
              motion_pace = "base";
              reduce_motion = "system";
              rounding = "rounded";
              server_side_decorations = true;
              theme = "dark";
              theme_overrides = {
                background = null;
                border = null;
                danger = null;
                danger_foreground = null;
                danger_hover = null;
                font_size = null;
                foreground = null;
                muted = null;
                muted_foreground = null;
                overlay = null;
                overlay_foreground = null;
                popover = null;
                popover_foreground = null;
                primary = null;
                primary_foreground = null;
                primary_hover = null;
                progress_bar = null;
                radius = null;
                secondary = null;
                secondary_active = null;
                secondary_hover = null;
                selection = null;
                sidebar = null;
                sidebar_accent = null;
                sidebar_border = null;
                table_active = null;
                table_active_border = null;
                table_head = null;
                table_head_foreground = null;
                table_hover = null;
                table_row_border = null;
                title_bar_border = null;
              };
              traffic_light_controls = false;
              transparency = 0.15;
              transparent = false;
              visualizer = true;
              visualizer_absolute = false;
              visualizer_style = "both";
              window_controls = true;
              window_rounding = "square";
            };
            artwork_for_local_files = true;
            blur_lyrics = true;
            check_updates = false;
            close_to_tray = false;
            discord_badge = true;
            discord_name = "sonora";
            discord_presence = true;
            discord_provider_button = true;
            discord_show_paused = true;
            discord_sonora_button = true;
            discord_without_details = false;
            equalizer = false;
            equalizer_bands = [
              0
              0
              0
              0
              0
              0
              0
              0
              0
              0
            ];
            font = config.custom.fonts.regular;
            fullscreen_lyrics_scale = 1;
            gapless = true;
            karaoke_lyrics = true;
            language = "auto";
            local_folders = ["${config.hjem.users.${user}.directory}/Music"];
            local_lyrics_offered = false;
            lyrics_for_local_files = true;
            lyrics_providers = [
              "Local"
              "Spotify"
              "YouTube Music"
              "Apple Music"
              "Musixmatch"
              "LrcLib"
            ];
            normalisation = true;
            panel_lyrics_scale = 1;
            prefer_local_lyrics = false;
            romanization_scripts = {
              arabic = false;
              chinese = true;
              cyrillic = false;
              greek = false;
              japanese = true;
              korean = true;
              other = false;
            };
            romanized_lyrics = true;
            sleep_timer = false;
            startup = "home";
            stay_awake = true;
            tray_icon = true;
          });
      };
    };

    custom.fileSystem = {
      cache.home.directories = [
        ".cache/sonora"
        ".local/share/sonora"
        ".local/state/sonora"
      ];
    };
  };
}
