{lib, ...}: let
  inherit (lib) singleton;

  dispatch = {mods ? "NONE"}: keys: cmds: "${mods},${keys},${cmds}" |> singleton;
  spawn = {mods ? "NONE"}: keys: cmds: "${mods},${keys},spawn,${cmds}" |> singleton;
  keymode = {mods ? "NONE"}: keys: cmds: "${mods},${keys},setkeymode,${cmds}" |> singleton;
in {
  bind =
    # Dispatchers
    # Window Management
    dispatch {mods = "SUPER";} "Backspace" "killclient" # Close the focused window. If force is specified, sends SIGKILL.
    ++ dispatch {mods = "SUPER";} "F" "togglemaximizescreen" # Maximize window (keep decoration/bar)
    ++ dispatch {mods = "SUPER+SHIFT";} "F" "togglefullscreen" # Toggle fullscreen
    ++ dispatch {mods = "SUPER+ALT";} "F" "togglefakefullscreen" # Toggle "fake" fullscreen (remains constrained)
    ++ dispatch {mods = "SUPER";} "T" "togglefloating" # Toggle floating state
    ++ dispatch {mods = "SUPER";} "C" "centerwin" # Center the floating window
    ++ dispatch {mods = "SUPER";} "G" "toggleglobal" # Pin widnow to all tags
    ++ dispatch {mods = "SUPER";} "I" "minimized" # Minimize window to scratchpad
    ++ dispatch {mods = "ALT";} "Z" "toggle_scratchpad" # Toggle scratchpad
    ++ dispatch {mods = "SUPER+SHIFT";} "I" "restore_minimized,0" # Restore minimized window to its previous state. 1 means keep previous tags, 0 means restore to current tags.
    ++ dispatch {mods = "SUPER";} "O" "overcircle,next" # Open overview when closed; while it is open, cycle focus to the next/previous window on the current monitor.
    ++ dispatch {mods = "ALT";} "F4" "quit" # Exit mangowm.
    # Focus & Movement
    # Focus window in direction
    ++ dispatch {mods = "SUPER";} "H" "focusdir,left"
    ++ dispatch {mods = "SUPER";} "J" "focusdir,down"
    ++ dispatch {mods = "SUPER";} "K" "focusdir,up"
    ++ dispatch {mods = "SUPER";} "L" "focusdir,right"
    # Swap window with neighbor in direction
    ++ dispatch {mods = "SUPER+SHIFT";} "H" "exchange_client,left"
    ++ dispatch {mods = "SUPER+SHIFT";} "J" "exchange_client,down"
    ++ dispatch {mods = "SUPER+SHIFT";} "K" "exchange_client,up"
    ++ dispatch {mods = "SUPER+SHIFT";} "L" "exchange_client,right"
    # Tags & Monitors
    ++ dispatch {mods = "SUPER";} "1" "view,1"
    ++ dispatch {mods = "SUPER";} "2" "view,2"
    ++ dispatch {mods = "SUPER";} "3" "view,3"
    ++ dispatch {mods = "SUPER";} "4" "view,4"
    ++ dispatch {mods = "SUPER";} "5" "view,5"
    ++ dispatch {mods = "SUPER";} "6" "view,6"
    ++ dispatch {mods = "SUPER";} "7" "view,7"
    ++ dispatch {mods = "SUPER";} "8" "view,8"
    ++ dispatch {mods = "SUPER";} "9" "view,9"
    ++ dispatch {mods = "SUPER+SHIFT";} "1" "tag,1"
    ++ dispatch {mods = "SUPER+SHIFT";} "2" "tag,2"
    ++ dispatch {mods = "SUPER+SHIFT";} "3" "tag,3"
    ++ dispatch {mods = "SUPER+SHIFT";} "4" "tag,4"
    ++ dispatch {mods = "SUPER+SHIFT";} "5" "tag,5"
    ++ dispatch {mods = "SUPER+SHIFT";} "6" "tag,6"
    ++ dispatch {mods = "SUPER+SHIFT";} "7" "tag,7"
    ++ dispatch {mods = "SUPER+SHIFT";} "8" "tag,8"
    ++ dispatch {mods = "SUPER+SHIFT";} "9" "tag,9"
    # Execute
    ++ spawn {mods = "SUPER";} "Return" "kitty"
    ++ spawn {mods = "SUPER+SHIFT";} "Return" "kitty --app-id app.nvim nvim"
    ++ spawn {mods = "SUPER+SHIFT";} "N" "kitty --app-id app.ns ns"
    ++ spawn {mods = "SUPER+SHIFT";} "Y" "kitty --app-id app.yazi yazi"
    ++ spawn {mods = "SUPER";} "B" "brave-origin"
    ++ spawn {mods = "SUPER";} "Space" "noctalia msg panel-toggle launcher"
    ++ spawn {mods = "SUPER";} "Y" "noctalia msg panel-toggle clipboard"
    ++ spawn {mods = "SUPER";} "Comma" "noctalia msg settings-toggle"
    ++ spawn {mods = "SUPER";} "W" "noctalia msg panel-toggle wallpaper"
    ++ spawn {mods = "SUPER+SHIFT";} "W" "noctalia msg panel-toggle noctalia/mpvpaper:picker"
    ++ spawn {mods = "SUPER";} "X" "noctalia msg panel-toggle session"
    # misc.
    ++ spawn {} "Print" "noctalia msg screenshot-region"
    ++ spawn {mods = "SHIFT";} "Print" "noctalia msg screenshot-fullscreen pick"
    ++ spawn {mods = "CTRL";} "Space" "fcitx5-remote -t"
    # setKeymode
    ++ keymode {mods = "ALT";} "R" "resize"; # Enter resize mode

  # Allow when locked
  bindl =
    spawn {} "XF86AudioRaiseVolume" "noctalia msg volume-up"
    ++ spawn {} "XF86AudioLowerVolume" "noctalia msg volume-down"
    ++ spawn {} "XF86AudioMute" "noctalia msg volume-mute"
    ++ spawn {} "XF86AudioPlay" "noctalia msg media toggle"
    ++ spawn {} "XF86AudioPrev" "noctalia msg media previous"
    ++ spawn {} "XF86AudioNext" "noctalia msg media next"
    ++ spawn {} "XF86MonBrightnessUp" "noctalia msg brightness-up"
    ++ spawn {} "XF86MonBrightnessDown" "noctalia msg brightness-down";

  gesturebind =
    dispatch {} "Left,3" "focusdir,right"
    ++ dispatch {} "Right,3" "focusdir,left"
    ++ dispatch {} "Up,3" "focusdir,down"
    ++ dispatch {} "Down,3" "focusdir,up";

  # Keymodes (submaps) for modal keybindings
  keymode = {
    resize = {
      bind =
        dispatch {} "Left" "resizewin,-10,0"
        ++ dispatch {} "Right" "resizewin,+10,0"
        ++ dispatch {} "Up" "resizewin,0,+10"
        ++ dispatch {} "Down" "resizewin,0,-10"
        ++ dispatch {} "Escape" "setkeymode,default";
    };
  };
}
