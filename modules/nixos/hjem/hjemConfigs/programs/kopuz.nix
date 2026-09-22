{inputs, ...}: {
  flake.custom.hjemConfigs.kopuz = {
    pkgs,
    user,
    ...
  }: let
    kopuzPkg = inputs.kopuz.packages.${pkgs.stdenv.hostPlatform.system}.default;
  in {
    hjem.users.${user} = {
      packages = [
        kopuzPkg
      ];

      xdg.config.files = let
        tomlFmt = pkgs.formats.toml {};
      in {
        "kopuz/settings.toml" = {
          source = tomlFmt.generate "kopuz-settings.toml" {
            album_view_mode = "Grid";
            artist_album_view_mode = "Grid";
            artist_view_order = "Tracks";
            artists_view_mode = "Grid";
            auto_check_updates = false;
            auto_fetch_covers = true;
            back_behavior = "RewindThenPrev";
            channel_mode = "Stereo";
            cover_art_background = true;
            cover_art_blur = 0;
            cover_art_darkening = 60;
            cover_fetch_strategy = "MusicBrainzFirst";
            crossfade_seconds = 0;
            custom_background_path = "";
            custom_font_path = "";
            device_change_behavior = "Pause";
            discord_presence = true;
            discord_presence_paused = true;
            discord_presence_source = true;
            enable_musixmatch_lyrics = false;
            fullscreen_use_player_bar = false;
            hero_height = 300;
            language = "ja";
            lastfm_api_key = "";
            lastfm_api_secret = "";
            lastfm_session_key = "";
            librefm_api_key = "";
            librefm_api_secret = "";
            librefm_session_key = "";
            listen_now_style = "List";
            live_theme_path = "";
            local_sources = [];
            lyrics_depth_blur = true;
            lyrics_depth_blur_strength = 100;
            lyrics_offset_auto = true;
            lyrics_offset_ms = 0;
            minimize_to_tray = false;
            music_directory = ["/home/${user}/Music"];
            musicbrainz_token = "";
            offline_quality = "Kbps320";
            pinned_stations = [];
            player_bar_position = "Bottom";
            prefer_local_lyrics = false;
            reduce_animations = false;
            sample_rate_mode = "System";
            settings_layout = "Cd";
            show_row_images = true;
            show_source_toggle = true;
            sidebar_order = [
              "home"
              "search"
              "library"
              "albums"
              "artists"
              "playlists"
              "favorites"
              "radio"
              "activity"
              "downloader"
            ];
            sort_order = "Title";
            spotify_prefer_active_device = true;
            theme = "catppuccin";
            titlebar_mode = "Custom";
            tracing_enabled = false;
            ui_style = "Normal";
            volume = 1.0;
            volume_scroll_step = 0.05;
            ytdlp_output_dir = "";

            active_source = {
              Server = "18e868f7-05cf-4490-bf59-6f26f131b045";
            };
            album_sort = [
              {
                direction = "Asc";
                field = "Title";
              }
            ];

            artist_album_sort = [
              {
                direction = "Asc";
                field = "Title";
              }
            ];

            artist_sort = [
              {
                direction = "Asc";
                field = "Name";
              }
            ];
            custom_themes = {};

            equalizer = {
              bands = [
                0.0
                0.0
                0.0
                0.0
                0.0
                0.0
                0.0
                0.0
                0.0
                0.0
              ];
              enabled = false;
              preamp_db = 0.0;
              preset = "Flat";
            };
            home_sections = [
              {
                enabled = true;
                key = "hero";
              }
              {
                enabled = true;
                key = "continue_listening";
              }
              {
                enabled = true;
                key = "listen_now";
              }
              {
                enabled = true;
                key = "top_artists";
              }
              {
                enabled = true;
                key = "new_releases";
              }
              {
                enabled = true;
                key = "made_for_you";
              }
              {
                enabled = true;
                key = "recently_added";
              }
              {
                enabled = true;
                key = "playlists";
              }
            ];

            library_sort = [
              {
                direction = "Asc";
                field = "Title";
              }
            ];
            radio_registries = [
              {
                enabled = true;
                is_default = true;
                url = "https://raw.githubusercontent.com/Kopuz-org/kopuz/refs/heads/master/radio-registry/index.json";
              }
            ];

            server_folders = {};

            ytdlp_options = {
              audio_quality = 0;
              convert_thumbnail = "";
              cookies_from_browser = "";
              embed_chapters = false;
              embed_info_json = false;
              embed_metadata = true;
              embed_subs = false;
              embed_thumbnail = true;
              js_runtimes = "";
              no_mtime = false;
              no_playlist = false;
              postprocess_thumbnail_square = false;
              rate_limit = "";
              split_chapters = false;
              sponsorblock = false;
              sponsorblock_mark = false;
              write_auto_subs = false;
              write_comments = false;
              write_description = false;
              write_info_json = false;
              write_subs = false;
              write_thumbnail = false;
              xattrs = false;
            };
          };
        };
      };
    };

    custom.fileSystem = {
      persist.home.directories = [
        ".config/kopuz"
      ];
      cache.home.directories = [
        ".cache/kopuz"
        ".local/share/kopuz"
      ];
    };
  };
}
