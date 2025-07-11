{ pkgs, ... }:
pkgs.writers.writeFishBin "fuzzel-recorder" ''
  set choices " Screen
   Area
  󰵸 Gif Convertion"

  set choice (echo -en $choices | fuzzel --dmenu --prompt " " --placeholder "Search for Recorder actions..." --lines 3)

  switch (string split -f 2 " " $choice)
      case Screen
          record_screen -s
      case Area
          record_screen -a
      case Gif
          record_screen -g
  end
''
