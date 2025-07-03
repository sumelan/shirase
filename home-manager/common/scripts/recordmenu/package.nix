{ pkgs, ... }:
pkgs.writers.writeFishBin "fuzzel-recorder" ''
  set choices " Record-Screen
   Record-Area
  󰵸 Record-toGif
   Quit-Recording"

  set choice (echo -en $choices | fuzzel --dmenu --prompt " " --placeholder "Search for Recorder actions..." --lines 4)

  switch (string split -f 2 " " $choice)
      case Record-Screen
          record_screen -s
      case Record-Area
          record_screen -a
      case Record-toGif
          record_screen -g
      case Quit-Recording
          record_screen -q
  end
''
