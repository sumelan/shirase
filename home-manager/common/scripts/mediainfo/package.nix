{ pkgs, ... }:
pkgs.writers.writeFishBin "write_media_info" ''
  set MAXINFO 28
  set PLAYER "spotify"

  set player_status (playerctl -p $PLAYER status 2> /dev/null )
  if  string match $player_status "Playing" > /dev/null
      set artist (playerctl -p $PLAYER metadata xesam:artist)
      set title (playerctl -p $PLAYER metadata xesam:title)
      set info " | $artist - $title"
      if test (string length $info) -gt $MAXINFO
          set short (string shorten -m $MAXINFO $info)
          echo "$short"
      else
          echo "$info"
      end
  else if string match $player_status "Paused" > /dev/null
      echo " | Paused..."
  end
''
