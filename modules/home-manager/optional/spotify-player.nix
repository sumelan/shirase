{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit
    (lib.custom.colors)
    gray1
    gray2
    gray5
    white0
    white2
    white3
    blue0
    blue2
    yellow_base
    yellow_bright
    cyan_base
    cyan_bright
    red_base
    red_bright
    green_base
    green_bright
    magenta_base
    magenta_bright
    ;
  inherit (lib.custom.niri) spawn hotkey;
in {
  options.custom = {
    spotify-player.enable = mkEnableOption "A Spotify player in the terminal with full feature parity";
  };

  config = mkIf config.custom.spotify-player.enable {
    programs = {
      spotify-player = {
        enable = true;
        themes = [
          {
            name = "nord";
            palette = {
              background = gray1;
              foreground = white3;
              black = gray2;
              red = red_base;
              green = green_base;
              yellow = yellow_base;
              blue = blue2;
              magenta = magenta_base;
              cyan = cyan_base;
              white = white2;
              bright_black = gray5;
              bright_red = red_bright;
              bright_green = green_bright;
              bright_yellow = yellow_bright;
              bright_blue = blue0;
              bright_magenta = magenta_bright;
              bright_cyan = cyan_bright;
              bright_white = white0;
            };
          }
        ];
        settings = {
          theme = "nord";
          playback_format = "{status} {track} • {artists}\n{album} • {genres}\n{metadata}";
          notify_format = {
            summary = "{track} • {artists}";
            body = "{album}";
          };
          default_device = "spotify_player";
          copy_command = {
            command = "wl-copy";
            args = [];
          };
          device = {
            name = "spotify_player";
            device_type = "speaker";
            audio_cache = false;
            normalization = false;
          };
          layout = {
            library = {
              playlist_percent = 40;
              album_percent = 40;
            };
            playback_window_position = "Top";
          };
        };
      };

      niri.settings.binds = {
        "Mod+Shift+S" = {
          action.spawn = spawn "foot --app-id=spotify spotify_player";
          hotkey-overlay.title = hotkey {
            color = green_base;
            name = "  spotify_player";
            text = "Terminal Spotify Client";
          };
        };
      };
    };

    custom.persist = {
      home.directories = [
        # credenctials.json
        ".cache/spotify-player"
      ];
    };
  };
}
