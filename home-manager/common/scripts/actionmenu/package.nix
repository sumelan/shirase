{ pkgs, lib, ... }:
pkgs.writers.writeFishBin "fuzzel-actions" ''
  set choices " Lock
   Suspend
  󰿅 Exit
   Reboot
   Power Off
   Next Wallpaper"

  set choice (echo -en $choices | fuzzel --dmenu --prompt " " --placeholder "Search for System actions..." --lines 6)

  switch (string split -f 2 " " $choice)
      case Lock
          ${lib.getExe pkgs.hyprlock}
      case Suspend
          systemctl suspend
      case Exit
          niri msg action quit
      case Reboot
          systemctl reboot
      case Power
          systemctl poweroff
      case Next
          ${lib.getExe' pkgs.wpaperd "wpaperctl"} next
  end
''
