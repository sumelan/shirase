{
  cfg,
  pkgs,
  data,
  music,
  playlists,
  db,
  ...
}:
pkgs.writeText "mpd.conf" (''
    music_directory     "${music}"
    playlist_directory  "${playlists}"
  ''
  + ''
    db_file             "${db}"
  ''
  + ''
    state_file          "${data}/state"
    sticker_file        "${data}/sticker.sql"
  ''
  + pkgs.lib.optionalString (cfg.settings.bind_to_address != "any") ''
    bind_to_address     "${cfg.settings.bind_to_address}"
  ''
  + pkgs.lib.optionalString (cfg.settings.port != 6600) ''
    port                "${toString cfg.settings.port}"
  ''
  + ''
    audio_output {
      name              "PipeWire Sound Server"
      type              "pipewire"
    }

    audio_output {
      format            "48000:16:2"
      name              "FIFO"
      path              "/run/user/1000/mpd/mpd.fifo"
      type              "fifo"
    }
  '')
