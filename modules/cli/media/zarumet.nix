{config, ...}: let
  inherit
    (config.flake.lib.colors)
    black2
    gray0
    white0
    white3
    blue0
    blue1
    blue2
    yellow_bright
    cyan_bright
    green_bright
    orange_bright
    magenta_bright
    ;
in {
  flake.modules.homeManager.zarumet = {config, ...}: let
    mpdAddress = config.services.mpd.network.listenAddress;
  in {
    programs.zarumet = {
      enable = true;
      settings = {
        mpd = {
          address = mpdAddress;
          volume_increment = 5;
          volume_increment_fine = 1;
        };
        colors = {
          border = white3;
          song_title = blue2;
          album = green_bright;
          artist = magenta_bright;
          border_title = blue0;
          progress_filled = magenta_bright;
          progress_empty = gray0;
          paused = cyan_bright;
          playing = cyan_bright;
          stopped = cyan_bright;
          time_separator = gray0;
          time_duration = white3;
          time_elapsed = white0;
          queue_selected_highlight = blue1;
          queue_selected_text = black2;
          queue_album = green_bright;
          queue_song_title = blue2;
          queue_artist = magenta_bright;
          queue_position = orange_bright;
          queue_duration = orange_bright;
          top_accent = magenta_bright;
          volume = green_bright;
          volume_empty = gray0;
          mode = yellow_bright;
          track_duration = orange_bright;
        };
        binds = {
          next = [
            ">"
            "shift-j"
            "shift-down"
          ];
          previous = [
            "<"
            "shift-k"
            "shift-up"
          ];
          toggle_play_pause = [
            "space"
            "p"
          ];
          volume_up = ["="];
          volume_up_fine = ["+"];
          volume_down = ["-"];
          volume_down_fine = ["_"];
          toggle_mute = ["m"];
          cycle_mode_right = [
            "tab"
          ];
          cycle_mode_left = [
            "shift-tab"
          ];
          clear_queue = ["shift-d"];
          repeat = ["r"];
          random = ["z"];
          single = ["s"];
          consume = ["c"];
          quit = [
            "esc"
            "q"
          ];
          refresh = ["u"];
          switch_to_queue_menu = ["1"];
          switch_to_artists = ["2"];
          switch_to_albums = ["3"];
          seek_forward = [
            "shift-l"
            "shift-right"
          ];
          seek_backward = [
            "shift-h"
            "shift-left"
          ];
          scroll_up = [
            "k"
            "up"
          ];
          scroll_down = [
            "j"
            "down"
          ];
          play_selected = [
            "enter"
            "l"
            "right"
          ];
          remove_from_queue = [
            "x"
            "backspace"
            "d d"
          ];
          move_up_in_queue = [
            "ctrl-k"
            "ctrl-up"
          ];
          move_down_in_queue = [
            "ctrl-j"
            "ctrl-down"
          ];
          switch_panel_left = [
            "h"
            "left"
          ];
          switch_panel_right = [
            "l"
            "right"
          ];
          toggle_album_expansion = [
            "l"
            "right"
          ];
          add_to_queue = [
            "a"
            "enter"
          ];
          scroll_up_big = ["ctrl-u"];
          scroll_down_big = ["ctrl-d"];
          go_to_top = ["g g"];
          go_to_bottom = ["shift-g"];
          toggle_bit_perfect = ["b"];
        };
        pipewire = {
          bit_perfect_enabled = true;
        };
        logging = {
          enabled = true;
          level = "info";
          log_to_console = false;
          append_to_file = true;
          rotate_logs = true;
          rotation_size_mb = 10;
          keep_log_files = 5;
        };
      };
    };
  };
}
