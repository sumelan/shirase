{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit
    (lib.custom.colors)
    gray5
    white0
    white1
    white2
    white3
    blue0
    blue1
    blue2
    yellow_base
    cyan_bright
    red_base
    red_bright
    green_bright
    orange_base
    orange_bright
    magenta_bright
    ;
  inherit (lib.custom.niri) spawn hotkey;
in {
  options.custom = {
    youtube-tui.enable = mkEnableOption "Aesthetically pleasing YouTube TUI written in Rust";
  };

  config = mkIf config.custom.youtube-tui.enable {
    home.packages = [pkgs.youtube-tui];

    xdg.configFile = {
      "youtube-tui/main.yml".source = (pkgs.formats.yaml {}).generate "main" {
        mouse_support = true;
        invidious_instance = "invidious.f5.si"; # jp server
        write_config = "Dont";
        allow_unicode = true;
        message_bar_default = "All good :)";
        images = "Sixels";
        refresh_after_modifying_search_filters = true;
        syncing = {
          download_images = true;
          sync_channel_info = true;
          sync_channel_cooldown_secs = 86400;
          sync_videos_cooldown_secs = 600;
        };
        limits = {
          watch_history = 50;
          search_history = 75;
          commands_history = 75;
        };
        image_index = 4;
        provider = "YouTube";
        shell = "fish";
        legacy_input_handling = false;
        env = {
          video-player = "mpv";
          download-path = "${config.xdg.userDirs.download}/%(title)s-%(id)s.%(ext)s";
          terminal-emulator = "ghostty";
          youtube-downloader = "yt-dlp";
          save-path = "${config.xdg.dataHome}/youtube-tui/saved/";
          browser = "librewolf";
        };
      };

      "youtube-tui/commands.yml".source = (pkgs.formats.yaml {}).generate "commands" {
        # the key commands select the searchbar on launch
        launch_command = "loadpage library ;; flush ;; history clear ;; key Esc 0 ;; key Up 0 ;; key Up 0 ;; key Left 0 ;; key Enter 0";
        video = [
          # remove the cached info first, then reload the page
          "Reload updated video: run rm '~/.cache/youtube-tui/info/\${id}.json' ;; video \${id}"
          "Play video: parrun \${video-player} '\${embed-url}'"
          "Play audio: mpv stop ;; resume ;; mpv sprop loop-file no ;; mpv loadfile '\${embed-url}' ;; echo mpv Player started"
          "Play audio (loop): mpv stop ;; resume ;; mpv sprop loop-file inf ;; mpv loadfile '\${embed-url}' ;; echo mpv Player started"
          "View channel: channel \${channel-id}"
          "Subscribe to channel: sync \${channel-id}"
          "Open in browser: parrun \${browser} '\${url}'"
          "Toggle bookmark: togglemark \${id}"
          "Save video to library: bookmark \${id} ;; run rm -rf '\${save-path}\${id}.*' ;; parrun \${terminal-emulator} \${youtube-downloader} '\${embed-url}' -o '\${save-path}%(title)s[%(id)s].%(ext)s'"
          "Save audio to library: bookmark \${id} ;; parrun rm -rf '\${save-path}\${id}.*' ;; parrun \${terminal-emulator} \${youtube-downloader} '\${embed-url}' -x -o '\${save-path}%(title)s[%(id)s].%(ext)s'"
          "'Mode: \${provider}': switchprovider"
        ];
      };

      "youtube-tui/keybindings.yml".source = (pkgs.formats.yaml {}).generate "keybindings" {
        "q" = {
          "0" = "Exit";
        };
        "Down" = {
          "0" = "MoveDown";
        };
        "r" = {
          "2" = "Reload";
        };
        "Enter" = {
          "0" = "Select";
        };
        "l" = {
          "0" = "MoveRight";
        };
        "Up" = {
          "0" = "MoveUp";
        };
        "j" = {
          "0" = "MoveDown";
        };
        "End" = {
          "0" = "ClearHistory";
        };
        "Right" = {
          "0" = "MoveRight";
        };
        "Backspace" = {
          "0" = "Back";
        };
        "h" = {
          "0" = "MoveLeft";
        };
        "F5" = {
          "0" = "Reload";
        };
        "k" = {
          "0" = "MoveUp";
        };
        "Esc" = {
          "0" = "Deselect";
        };
        "Home" = {
          "0" = "FirstHistory";
        };
        "Left" = {
          "0" = "MoveLeft";
          "4" = "Back";
        };
      };

      "youtube-tui/commandbindings.yml".source = (pkgs.formats.yaml {}).generate "commandbindings" {
        global = {
          "f" = {
            "2" = "run \${browser} '\${url}'";
          };
          "c" = {
            "2" = "cp \${url}";
          };
        };
        video = "{}";
        search = {
          "a" = {
            "2" = "run \${terminal-emulator} mpv '\${hover-url}' --no-video";
          };
          "A" = {
            "1" = "run \${terminal-emulator} mpv '\${hover-url}' --no-video --loop-playlist=inf --shuffle";
          };
          "p" = {
            "2" = "run mpv '\${hover-url}'";
          };
        };
        watchhistory = {
          "A" = {
            "1" = "run \${terminal-emulator} mpv '\${hover-url}' --no-video --loop-playlist=inf --shuffle";
          };
          "p" = {
            "2" = "run mpv '\${hover-url}'";
          };
          "a" = {
            "2" = "run \${terminal-emulator} mpv '\${hover-url}' --no-video";
          };
          # etc
        };
      };

      "youtube-tui/pages.yml".source = (pkgs.formats.yaml {}).generate "pages" {
        main_menu = {
          layout = [
            {
              type = "NonCenteredRow";
              items = [
                "SearchBar"
                "SearchFilters"
              ];
            }
            {
              type = "CenteredRow";
              items = [
                "Popular"
                "Trending"
                "History"
              ];
            }
            {
              type = "NonCenteredRow";
              items = [
                "ItemList"
              ];
            }
            {
              type = "NonCenteredRow";
              items = [
                "MessageBar"
              ];
            }
          ];
          message = "Loading main menu...";
          # this focuses on the search bar
          command = "key Esc 0 ;; key Up 0 ;; key Left 0 ;; key Enter 0";

          # and much more ...
        };
      };

      "youtube-tui/appearance.yml".source = (pkgs.formats.yaml {}).generate "appearance" {
        borders = "Rounded";
        colors = {
          text = white0;
          text_special = white3;
          text_secondary = white2;
          text_error = red_bright;
          outline = white1;
          outline_selected = orange_bright;
          outline_hover = blue0;
          outline_secondary = blue2;
          message_outline = "#FF7F00";
          message_error_outline = red_base;
          message_success_outline = blue1;
          item_info = {
            tag = gray5;
            title = orange_base;
            description = gray5;
            author = yellow_base;
            viewcount = green_bright;
            length = magenta_bright;
            published = cyan_bright;
            video_count = "#838DFF";
            sub_count = "#65FFBA";
            likes = "#C8FF81";
            genre = "#FF75D7";
            page_turner = gray5;
          };
        };
      };

      "youtube-tui/search.yml".source = (pkgs.formats.yaml {}).generate "search" {
        query = "";
        filters = {
          sort = "Relevance";
          date = "None";
          duration = "None";
          type = "All";
        };
      };

      "youtube-tui/cmdefine.yml".source = (pkgs.formats.yaml {}).generate "cmdefine" {
        print = "echo";
        pause = "mpv sprop pause yes ;; echo mpv Player paused";
        next = "mpv playlist-next ;; echo mpv Skipped";
        resume = "mpv sprop pause no ;; echo mpv Player resumed";
        search = "loadpage search";
        rc = "reload configs";
      };

      "youtube-tui/remap.yml".source = (pkgs.formats.yaml {}).generate "remap" {};
    };

    programs.niri.settings = {
      binds = {
        "Mod+Shift+Y" = {
          action.spawn = spawn "ghostty -e youtube-tui";
          hotkey-overlay.title = hotkey {
            color = red_base;
            name = "  youtube-tui";
            text = "Terminal YouTube Client";
          };
        };
      };
    };

    custom.persist = {
      home.directories = [
        ".local/share/youtube-tui"
      ];
    };
  };
}
