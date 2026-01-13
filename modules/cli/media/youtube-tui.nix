{lib, ...}: let
  inherit (lib) getExe;
in {
  flake.modules.homeManager.youtube-tui = {
    config,
    pkgs,
    ...
  }: let
    inherit (config.xdg.userDirs) download;
    inherit (config.xdg) dataHome;
  in {
    home.packages = [pkgs.youtube-tui];

    xdg.desktopEntries = {
      youtube-tui = {
        name = "YouTube-TUI";
        genericName = "YouTube Player";
        icon = "youtube";
        terminal = true;
        exec = getExe pkgs.youtube-tui;
      };
    };

    xdg.configFile = {
      "youtube-tui/main.yml".source = (pkgs.formats.yaml {}).generate "main" {
        mouse_support = true;
        invidious_instance = "https://inv.nadeko.net";
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
        textbar_scroll_behaviour = "Word";
        image_index = 4;
        provider = "YouTube";
        search_provider = "RustyPipe";
        shell = "fish";
        legacy_input_handling = false;
        env = {
          video-player = "mpv";
          download-path = "${download}/%(title)s-%(id)s.%(ext)s";
          terminal-emulator = "kitty";
          youtube-downloader = "yt-dlp";
          save-path = "${dataHome}/youtube-tui/saved/";
          browser = "xdg-open";
        };
      };

      "youtube-tui/commands.yml".source = (pkgs.formats.yaml {}).generate "commands" {
        # the key commands select the searchbar on launch
        launch_command = "loadpage library ;; flush ;; key Esc 0 ;; key Up 0 ;; key Up 0 ;; key Left 0 ;; key Enter 0";
        video = [
          {
            # remove the cached info first, then reload the page
            "Reload updated video" = "run rm '~/.cache/youtube-tui/info/\${id}.json' ;; video \${id}";
          }
          {
            "Play video" = "parrun \${video-player} '\${embed-url}'";
          }
          {
            "Play audio" = "mpv stop ;; resume ;; mpv sprop loop-file no ;; mpv loadfile '\${embed-url}' ;; echo mpv Player started";
          }
          {
            "Play audio (loop)" = "mpv stop ;; resume ;; mpv sprop loop-file inf ;; mpv loadfile '\${embed-url}' ;; echo mpv Player started";
          }
          {
            "View channel" = "channel \${channel-id}";
          }
          {
            "Subscribe to channel" = "sync \${channel-id}";
          }
          {
            "Open in browser" = "parrun \${browser} '\${url}'";
          }
          {
            "Toggle bookmark" = "togglemark \${id}";
          }
          {
            "Save video to library" = "bookmark \${id} ;; run rm -rf '\${save-path}\${id}.*' ;; parrun \${terminal-emulator} \${youtube-downloader} '\${embed-url}' -o '\${save-path}%(title)s[%(id)s].%(ext)s'";
          }
          {
            "Save audio to library" = "bookmark \${id} ;; parrun rm -rf '\${save-path}\${id}.*' ;; parrun \${terminal-emulator} \${youtube-downloader} '\${embed-url}' -x -o '\${save-path}%(title)s[%(id)s].%(ext)s'";
          }
          {
            "'Mode: \${provider}'" = "switchprovider";
          }
        ];
      };

      "youtube-tui/keybindings.yml".source = (pkgs.formats.yaml {}).generate "keybindings" {
        "'q'" = {
          "0" = "Exit";
        };
        Down = {
          "0" = "MoveDown";
        };
        "'r'" = {
          "2" = "Reload";
        };
        Enter = {
          "0" = "Select";
        };
        "'l'" = {
          "0" = "MoveRight";
        };
        Up = {
          "0" = "MoveUp";
        };
        "'j'" = {
          "0" = "MoveDown";
        };
        End = {
          "0" = "ClearHistory";
        };
        Right = {
          "0" = "MoveRight";
        };
        Backspace = {
          "0" = "Back";
        };
        "'h'" = {
          "0" = "MoveLeft";
        };
        F5 = {
          "0" = "Reload";
        };
        "'k'" = {
          "0" = "MoveUp";
        };
        Esc = {
          "0" = "Deselect";
        };
        Home = {
          "0" = "FirstHistory";
        };
        Left = {
          "0" = "MoveLeft";
          "4" = "Back";
        };
      };

      "youtube-tui/commandbindings.yml".source = (pkgs.formats.yaml {}).generate "commandbindings" {
        global = {
          "'f'" = {
            "2" = "run \${browser} '\${url}'";
          };
          "'c'" = {
            "2" = "cp \${url}";
          };
        };
        video = "{}";
        search = {
          "'a'" = {
            "2" = "run \${terminal-emulator} mpv '\${hover-url}' --no-video";
          };
          "'A'" = {
            "1" = "run \${terminal-emulator} mpv '\${hover-url}' --no-video --loop-playlist=inf --shuffle";
          };
          "'p'" = {
            "2" = "run mpv '\${hover-url}'";
          };
        };
        watchhistory = {
          "'A'" = {
            "1" = "run \${terminal-emulator} mpv '\${hover-url}' --no-video --loop-playlist=inf --shuffle";
          };
          "'p'" = {
            "2" = "run mpv '\${hover-url}'";
          };
          "'a'" = {
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
    };

    custom.persist.home.directories = [
      ".local/share/youtube-tui"
    ];
  };
}
