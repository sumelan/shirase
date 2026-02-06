{lib, ...}: let
  inherit (lib) getExe;
in {
  flake.modules.homeManager.youtube-tui = {pkgs, ...}: let
    inherit (pkgs.formats.yaml {}) generate;
  in {
    home.packages = [pkgs.youtube-tui];

    xdg = {
      desktopEntries = {
        youtube-tui = {
          name = "YouTube-tui";
          genericName = "YouTube Player";
          icon = "youtube";
          terminal = true;
          exec = getExe pkgs.youtube-tui;
        };
      };
      configFile = {
        "youtube-tui/main.yml".source = generate "youtube-tui/main.yml" {
          mouse_support = true;
          invidious_instance = "https://invidious.f5.si";
          write_config = "Try";
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
          textbar_scroll_behaviour = "History";
          image_index = 4;
          provider = "YouTube";
          search_provider = "RustyPipe";
          api_key = "YOUR API KEY HERE";
          shell = "sh";
          legacy_input_handling = false;
          env = {
            download-path = "~/Downloads/%(title)s-%(id)s.%(ext)s";
            terminal-emulator = "kitty";
            video-player = "mpv";
            browser = "xdg-open";
            youtube-downloader = "yt-dlp";
            save-path = "~/.local/share/youtube-tui/saved/";
          };
        };
        "youtube-tui/commands.yml".source = generate "youtube-tui/commands.yml" {
          "launch_command" = "loadpage library ;; flush ;; key Esc 0 ;; key Up 0 ;; key Up 0 ;; key Left 0 ;; key Enter 0";
          video = [
            {"Reload updated video" = "run rm '~/.cache/youtube-tui/info/\${id}.json' ;; video \${id}";}
            {"Play video" = "parrun \${video-player} '\${embed-url}'";}
            {"Play audio" = "mpv stop ;; resume ;; mpv sprop loop-file no ;; mpv loadfile '\${embed-url}' ;; echo mpv Player started";}

            {"Play audio (loop)" = "mpv stop ;; resume ;; mpv sprop loop-file inf ;; mpv loadfile '\${embed-url}' ;; echo mpv Player started";}
            {"View channel" = "channel \${channel-id}";}
            {"Subscribe to channel" = "sync \${channel-id}";}
            {"Open in browser" = "parrun \${browser} '\${url}'";}
            {"Toggle bookmark" = "togglemark \${id}";}
            {"Save video to library" = "bookmark \${id} ;; run rm -rf '\${save-path}\${id}.*' ;; parrun \${terminal-emulator} \${youtube-downloader} '\${embed-url}' -o '\${save-path}%(title)s[%(id)s].%(ext)s'";}
            {"Save audio to library" = "bookmark \${id} ;; parrun rm -rf '\${save-path}\${id}.*' ;; parrun \${terminal-emulator} \${youtube-downloader} '\${embed-url}' -x -o '\${save-path}%(title)s[%(id)s].%(ext)s'";}
            {"Mode: \${provider}" = "switchprovider";}
          ];
          saved_video = [
            {"Reload updated video" = "run rm '~/.cache/youtube-tui/info/\${id}.json' ;; video \${id}";}
            {"[Offline] Play saved file" = "parrun \${video-player} '\${offline-path}' --force-window";}
            {"[Offline] Play saved file (audio)" = "mpv stop ;; resume ;; mpv sprop loop-file no ;; mpv loadfile '\${offline-path}' ;; echo mpv Player started";}
            {"[Offline] Play saved file (audio loop)" = "mpv stop ;; resume ;; mpv sprop loop-file inf ;; mpv loadfile '\${offline-path}' ;; echo mpv Player started";}
            {"View channel" = "channel \${channel-id}";}
            {"Subscribe to channel" = "sync \${channel-id}";}
            {"Open in browser" = "parrun \${browser} '\${url}'";}
            {"Toggle bookmark" = "togglemark \${id}";}
            {"Redownload video to library" = "bookmark \${id} ;; run rm \${save-path}*\${id}*.* ;; parrun \${terminal-emulator} \${youtube-downloader} \${embed-url} -o '\${save-path}%(title)s[%(id)s].%(ext)s'";}
            {"Redownload audio to library" = "bookmark \${id} ;; run rm \${save-path}*\${id}*.* ;; parrun \${terminal-emulator} \${youtube-downloader} \${embed-url} -x -o '\${save-path}%(title)s[%(id)s].%(ext)s'";}
            {"Delete saved file" = "run rm \${save-path}*\${id}*.*";}
          ];
          playlist = [
            {"Switch view" = "'%switch-view%'";}
            {"Reload updated playlist" = "run rm ~/.cache/youtube-tui/info/\${id}.json ;; reload";}
            {"Play all (videos)" = "parrun \${video-player} \${url}";}
            {"Play all (audio)" = "mpv stop ;; resume ;; \${mpv-queuelist} ;; mpv sprop loop-playlist no ;; mpv playlist-play-index 0 ;; echo mpv Player started";}
            {"Shuffle play all (audio loop)" = "mpv stop ;; resume ;; \${mpv-queuelist} ;; mpv sprop loop-playlist yes ;; mpv playlist-shuffle ;; mpv playlist-play-index 0 ;; echo mpv Player started";}
            {"View channel" = "channel \${channel-id}";}
            {"Subscribe to channel" = "sync \${channel-id}";}
            {"Open in browser" = "parrun \${browser} '\${url}'";}
            {"Toggle bookmark" = "togglemark \${id}";}
            {"Save playlist videos to library" = ''bookmark ''${id} ;; run rm -rf "''${save-path}*''${id}*" ;; parrun ''${terminal-emulator} bash -c "''${youtube-downloader} ''${all-videos} -o ''${save-path}''${title}[''${id}]/%(title)s[%(id)s].%(ext)s"'';}
            {"Save playlist audio to library" = ''bookmark ''${id} ;; run rm -rf "''${save-path}*''${id}*" ;; parrun ''${terminal-emulator} bash -c "''${youtube-downloader} ''${all-videos} -x -o ''${save-path}''${title}[''${id}]/%(title)s[%(id)s].%(ext)s"'';}
            {"Mode: \${provider}" = "switchprovider";}
          ];
          saved_playlist = [
            {"Switch view" = "%switch-view%";}
            {"Reload updated playlist" = "run rm ~/.cache/youtube-tui/info/\${id}.json ;; reload";}
            {"[Offline] Play all (videos)" = "parrun \${video-player} \${save-path}*\${id}*/* --force-window";}
            {"[Offline] Play all (audio)" = "mpv stop ;; resume ;; \${offline-queuelist} ;; mpv sprop loop-playlist no ;; mpv playlist-play-index 0 ;; echo mpv Player started";}
            {"[Offline] Shuffle play all (audio loop)" = "mpv stop ;; resume ;; \${offline-queuelist} ;; mpv sprop loop-playlist yes ;; mpv playlist-shuffle ;; mpv playlist-play-index 0 ;; echo mpv Player started";}
            {"View channe" = "channel \${channel-id}";}
            {"Subscribe to channel" = "sync \${channel-id}";}
            {"Open in browser" = "parrun \${browser} '\${url}'";}
            {"Toggle bookmark" = "togglemark \${id}";}
            {"Redownload playlist videos to library" = ''bookmark ''${id} ;; run rm -rf ''${save-path}*''${id}* ;; parrun ''${terminal-emulator} bash -c "''${youtube-downloader} ''${all-videos} -o ''${save-path}''${title}[''${id}]/%(title)s[%(id)s].%(ext)s"'';}
            {"Redownload playlist audio to library" = ''bookmark ''${id} ;; run rm -rf ''${save-path}*''${id}* ;; parrun ''${terminal-emulator} bash -c "''${youtube-downloader} ''${all-videos} -x -o ''${save-path}''${title}[''${id}]/%(title)s[%(id)s].%(ext)s"'';}
            {"Delete saved files" = "run rm -rf \${save-path}*\${id}*";}
          ];
          channel = [
            {"Subscribe to channel" = "sync \${id}";}
            {"Play all (videos)" = "parrun \${video-player} \${url}";}
            {"Play all (audio)" = "mpv stop ;; resume ;; mpv loadfile \${url} ;; mpv sprop loop-playlist no ;; mpv playlist-play-index 0 ;; echo mpv Player started";}
            {"Shuffle play all (audio loop)" = "mpv stop ;; resume ;; mpv loadfile \${url} ;; mpv sprop loop-playlist yes ;; mpv playlist-shuffle ;; mpv playlist-play-index 0 ;; echo mpv Player started";}
          ];
        };
      };
    };

    custom.persist.home.directories = [
      ".local/share/youtube-tui"
    ];
  };
}
