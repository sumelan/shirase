#!/usr/bin/env fish

set choices " Lock
 Suspend
󰿅 Exit
 Reboot
 Poweroff
󰈿 Update Flag
󱄅 Update and Rebuild Flag"
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
    case Update Flag
        kitty touch $HOME/.cache/update-checler/nix-update-update-flag && pkill -x -RTMIN+12 .waybar-wrapped
    case Update and Rebuild Flag
        kitty touch $HOME/.cache/update-checker/nix-update-rebuild-flag && pkill -x -RTMIN+12 .waybar-wrapped
end
