{ pkgs, lib, ... }:
pkgs.writers.writeFishBin "fuzzel-actions" ''
  set choices " Lock
   Suspend
  󰿅 Exit
   Reboot
   Poweroff"

  set choice (echo -en $choices | fuzzel --dmenu --prompt " " --placeholder "Search for System actions..." --lines 5)

  switch (string split -f 2 " " $choice)
      case Lock
          ${lib.getExe pkgs.hyprlock}
      case Suspend
          systemctl suspend
      case Exit
          niri msg action quit
      case Reboot
          systemctl reboot
      case Poweroff
          systemctl poweroff
  end
''
