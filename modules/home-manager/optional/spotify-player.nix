{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  options.custom = {
    spotify-player.enable = mkEnableOption "A Spotify player in the terminal with full feature parity";
  };

  config = mkIf config.custom.spotify-player.enable {
    programs = {
      spotify-player = {
        enable = true;
        settings = {
          playback_format = "{status} {track} • {artists}\n{album} • {genres}\n{metadata}";
          notify_format = {
            summary = "{track} • {artists}";
            body = "{album}";
          };
          default_device = "spotify-player";
          copy_command = {
            command = "wl-copy";
            args = [];
          };
          device = {
            name = "spotify-player";
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
          action.spawn = ["foot" "--app-id=spotify-player" "spotify_player"];
          hotkey-overlay.title = ''<span foreground="#EFD49F">[  spotify-player]</span> Spotify TUI Client'';
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
