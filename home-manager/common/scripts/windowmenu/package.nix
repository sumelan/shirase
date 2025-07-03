{ pkgs, ... }:
pkgs.writers.writeFishBin "fuzzel-windows" ''
  set windows (niri msg -j windows)
  set ids (echo $windows | jq -r '.[] | .id')
  set app_ids (echo $windows | jq -r '.[] | .app_id' )
  set titles (echo $windows | jq -r '.[] | .title' )
  set choices ""

  for i in (seq (count $ids))
    set choices "$choices$titles[$i]\t$app_ids[$i]\0icon\x1f$app_ids[$i]\n"
  end

  set choices (string trim -c "\n" $choices)

  set choice (echo -e $choices | fuzzel --counter --dmenu --prompt " " --placeholder "Search for windows..." --index --tabs 200 || exit)
  if [ "x$choice" != "x" ] && [ $choice != -1 ]
    niri msg action focus-window --id $ids[(math $choice + 1)]
  end
''
