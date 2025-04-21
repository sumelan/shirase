#!/usr/bin/env fish

set choices " Lock
 Suspend
󰿅 Exit
 Reboot
 Poweroff
󱄅 Update"
set choice (echo -en $choices | fuzzel --dmenu --prompt " " --placeholder "Search for system actions..." --lines 5)

switch (string split -f 2 " " $choice)
    case Lock
        hyprlock
    case Suspend
        systemctl suspend
    case Exit
        niri msg action quit
    case Reboot
        systemctl reboot
    case Poweroff
        systemctl poweroff
    case Update
        niri msg spawn "kitty" "-T" "NixOS Update" "--app-id" "nh" "nh" "os" "switch" "-au"
end
