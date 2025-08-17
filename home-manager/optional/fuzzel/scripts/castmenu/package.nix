{pkgs, ...}:
pkgs.writers.writeFishBin "dynamic-screencast-target" ''
  set choices " Pick the target window\n󰍺 Focused Monitor\n󰞊 Clear Target"

  set choice (echo -en $choices | fuzzel --dmenu --prompt " " --placeholder "Search for Screencast targets..." --lines 3)

  switch (string split -f 2 " " $choice)
      case Pick
          niri msg action set-dynamic-cast-window --id (niri msg --json pick-window | jq .id)
      case Focused
          niri msg action set-dynamic-cast-monitor
      case Clear
          niri msg action clear-dynamic-cast-target
  end
''
