{
  cfg,
  pkgs,
  music,
  data,
  ...
}:
pkgs.writeText "mpd.conf" (''
    music_directory     "${music}"
    playlist_directory  "${data}/mpd/playlists"
  ''
  + ''
    db_file             "${data}/mpd/database"
  ''
  + ''
    state_file          "${data}/mpd/state"
    sticker_file        "${data}/mpd/sticker.sql"
  ''
  + pkgs.lib.optionalString (cfg.settings.bind_to_address != "any") ''
    bind_to_address     "${cfg.settings.bind_to_address}"
  ''
  + pkgs.lib.optionalString (cfg.settings.port != 6600) ''
    port                "${toString cfg.settings.port}"
  ''
  + ''
    audio_output {
        name          "PipeWire Sound Server"
        type          "pipewire"
    }

    audio_output {
        format        "48000:16:2"
        name          "FIFO"
        path          "/run/user/1000/mpd/mpd.fifo"
        type          "fifo"
    }
  '')
