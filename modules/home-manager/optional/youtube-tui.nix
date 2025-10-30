{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    getExe
    ;
  # Black
  black0 = "#191D24";
  black1 = "#1E222A";
  black2 = "#222630";

  # Gray
  gray0 = "#242933";
  # Polar night
  gray1 = "#2E3440";
  gray2 = "#3B4252";
  gray3 = "#434C5E";
  gray4 = "#4C566A";
  # a light blue/gray
  # from @nightfox.nvim
  gray5 = "#60728A";

  # White
  # reduce_blue variant
  white0 = "#C0C8D8";
  # Snow storm
  white1 = "#D8DEE9";
  white2 = "#E5E9F0";
  white3 = "#ECEFF4";

  # Blue
  # Frost
  blue0 = "#5E81AC";
  blue1 = "#81A1C1";
  blue2 = "#88C0D0";

  # Cyan:
  cyan_base = "#8FBCBB";
  cyan_bright = "#9FC6C5";
  cyan_dim = "#80B3B2";

  # Aurora (from Nord theme)
  # Red
  red_base = "#BF616A";
  red_bright = "#C5727A";
  red_dim = "#B74E58";

  # Orange
  orange_base = "#D08770";
  orange_bright = "#D79784";
  orange_dim = "#CB775D";

  # Yellow
  yellow_base = "#EBCB8B";
  yellow_bright = "#EFD49F";
  yellow_dim = "#E7C173";

  # Green
  green_base = "#A3BE8C";
  green_bright = "#B1C89D";
  green_dim = "#97B67C";

  # Magenta
  magenta_base = "#B48EAD";
  magenta_bright = "#BE9DB8";
  magenta_dim = "#A97EA1";
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
          terminal-emulator = "foot";
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
        "Mod+Y" = {
          action.spawn = ["${getExe pkgs.foot}" "--app-id=youtube-tui" "youtube-tui"];
          hotkey-overlay.title = ''<span foreground="#EFD49F">[  youtube-tui]</span> YouTube TUI Client'';
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
