#!/usr/bin/env fish

set choices " Lock
 Suspend
󰿅 Exit
 Reboot
 Poweroff
󰚰 Check Update
󱄅 Run Update"
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
    case Check Update
        niri msg action spawn -- kitty -T '󰚰 Check Update' --app-id checkup just checkup
    case Run Update
        niri msg action spawn -- kitty -T '󱄅 Run Update' --app-id nixup just nixup
end
