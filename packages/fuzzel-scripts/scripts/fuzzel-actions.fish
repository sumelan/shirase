#!/usr/bin/env fish

set choices " Lock
 Suspend
󰿅 Exit
 Reboot
 Poweroff
󰚰 Restart Waybar
󱄅 Fastfetch"
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
    case Restart Waybar
        niri msg action spawn -- kitty -T '󰚰 Restart Waybar' --app-id waybar systemctl --user restart waybar.service
    case Fastfetch
        niri msg action spawn -- kitty -T '󱄅 Fastfetch' --app-id fastfetch fastfetch
end
