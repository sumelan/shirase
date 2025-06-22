#!/usr/bin/env fish

if test (playerctl -p spotify status) = Playing
    set length (playerctl -p spotify metadata mpris:length)
    set position (playerctl -p spotify position)
    math $position / $length x 1000000
end
