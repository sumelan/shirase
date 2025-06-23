#!/usr/bin/env fish

if test (playerctl -p spotify status) = Playing
    set artist (playerctl -p spotify metadata xesam:artist)
    set title (playerctl -p spotify metadata xesam:title)
    echo " $artist - $title"
else if test (playerctl -p spotify status) = Paused
    echo " - Paused -"
end
