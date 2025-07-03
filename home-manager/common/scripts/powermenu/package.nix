{ lib, pkgs, ... }:
pkgs.writers.writeFishBin "fuzzel-power" ''
  set APP_NAME "Power Selector"

  function notify -a 1 2
      ${lib.getExe' pkgs.libnotify "notify-send"} -a "$APP_NAME" -i "battery" "$1" "$2"
  end

  set choices " Power-saver
   Balanced
   Performance"

  set choice (echo -en $choices | fuzzel --dmenu --prompt "󱉓? " --placeholder "Select Power Profile..." --lines 3)

  switch (string split -f 2 " " $choice)
      case Power-saver
          powerprofilesctl set power-saver
          notify " Power-saver" "Profile switched"
      case Balanced
          powerprofilesctl set balanced
          notify " Balanced" "Profile switched"
      case Performance
          powerprofilesctl set performance
          notify " Performance" "Profile switched"
  end
''
