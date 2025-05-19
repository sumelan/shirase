#!/usr/bin/env fish

set choices " Lock
 Suspend
󰿅 Exit
 Reboot
 Poweroff
󱄅 Switch
 Update"
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
    case Switch
        niri msg action spawn -- kitty -T 'NixOS Switch' --app-id nh-switch nh os switch -a
    case Update
        niri msg action spawn -- kitty -T 'NixOS Update' --app-id nh-update nh os switch -au
end
