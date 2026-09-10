{lib, ...}: let
  inherit (lib) singleton;

  dispatch = {mods ? "NONE"}: keys: cmds: "${mods},${keys},${cmds}" |> singleton;
  spawn = {mods ? "NONE"}: keys: cmds: "${mods},${keys},spawn,${cmds}" |> singleton;
  keymode = {mods ? "NONE"}: keys: cmds: "${mods},${keys},setkeymode,${cmds}" |> singleton;
in {
  bind =
    # Dispatchers
    ## Window Management
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
    ++ dispatch {mods = "SUPER";} "O" "toggleoverview" # Toggle overview mode.
    ++ dispatch {mods = "ALT";} "F4" "quit" # Exit mangowm.
    # Focus & Movement
    ## Focus window in direction
    ++ dispatch {mods = "SUPER";} "H" "focusdir,left"
    ++ dispatch {mods = "SUPER";} "J" "focusdir,down"
    ++ dispatch {mods = "SUPER";} "K" "focusdir,up"
    ++ dispatch {mods = "SUPER";} "L" "focusdir,right"
    ## Swap window with neighbor in direction
    ++ dispatch {mods = "SUPER+SHIFT";} "H" "exchange_client,left"
    ++ dispatch {mods = "SUPER+SHIFT";} "J" "exchange_client,down"
    ++ dispatch {mods = "SUPER+SHIFT";} "K" "exchange_client,up"
    ++ dispatch {mods = "SUPER+SHIFT";} "L" "exchange_client,right"
    # Floating Window Movement
    ## Move floating window by snap distance.
    ++ dispatch {mods = "ALT";} "H" "smartmovewin,left"
    ++ dispatch {mods = "ALT";} "J" "smartmovewin,down"
    ++ dispatch {mods = "ALT";} "K" "smartmovewin,up"
    ++ dispatch {mods = "ALT";} "L" "smartmovewin,right"
    ## Resize floating window by snap distance.
    ++ dispatch {mods = "CTRL";} "H" "smartresizewin,left"
    ++ dispatch {mods = "CTRL";} "J" "smartresizewin,down"
    ++ dispatch {mods = "CTRL";} "K" "smartresizewin,up"
    ++ dispatch {mods = "CTRL";} "L" "smartresizewin,right"
    # Tags & Monitors
    ## View and move
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
    ## Left or right
    ++ dispatch {mods = "SUPER";} "Left" "viewtoleft"
    ++ dispatch {mods = "SUPER";} "Right" "viewtoright"
    ++ dispatch {mods = "SUPER+ALT";} "Left" "viewtoleft_have_client"
    ++ dispatch {mods = "SUPER+ALT";} "Right" "viewtoright_have_client"
    ++ dispatch {mods = "SUPER+SHIFT";} "Left" "tagtoleft"
    ++ dispatch {mods = "SUPER+SHIFT";} "Right" "tagtoright"
    # Special Workspace (Tag 0)
    ++ dispatch {mods = "SUPER";} "S" "toggle_special_tag" # Toggle the special workspace overlay (Tag 0)
    ++ dispatch {mods = "SUPER+SHIFT";} "S" "tag_special_tag" # Move focused window to/from the special workspace
    ++ dispatch {mods = "SUPER+CTRL";} "S" "tag_special_silent" # Silently send active window to the special workspace without switching
    # Execute
    ## Main programs
    ++ spawn {mods = "SUPER";} "Return" "footclient"
    ++ spawn {mods = "SUPER+SHIFT";} "Return" "footclient --app-id app.nvim nvim"
    ++ spawn {mods = "SUPER+SHIFT";} "N" "footclient --app-id app.ns ns"
    ++ spawn {mods = "SUPER+SHIFT";} "Y" "footclient --app-id app.yazi yazi"
    ++ spawn {mods = "SUPER";} "B" "brave-origin"
    ## Noctalia
    ++ spawn {mods = "SUPER";} "Space" "noctalia msg panel-toggle launcher"
    ++ spawn {mods = "SUPER";} "Y" "noctalia msg panel-toggle clipboard"
    ++ spawn {mods = "SUPER";} "Comma" "noctalia msg settings-toggle"
    ++ spawn {mods = "SUPER";} "W" "noctalia msg panel-toggle wallpaper"
    ++ spawn {mods = "SUPER+SHIFT";} "W" "noctalia msg panel-toggle noctalia/mpvpaper:picker"
    ++ spawn {mods = "SUPER";} "X" "noctalia msg panel-toggle session"
    ## Misc.
    ++ spawn {} "Print" "noctalia msg screenshot-region"
    ++ spawn {mods = "SHIFT";} "Print" "noctalia msg screenshot-fullscreen pick"
    ++ spawn {mods = "CTRL";} "Space" "fcitx5-remote -t"
    # SetKeymode
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

  mousebind =
    dispatch {mods = "SUPER";} "btn_left" "moveresize,curmove"
    ++ dispatch {mods = "SUPER";} "btn_right" "moveresize,curresize";

  gesturebind =
    # 3-finger: Window focus
    dispatch {} "Left,3" "focusdir,right"
    ++ dispatch {} "Right,3" "focusdir,left"
    ++ dispatch {} "Up,3" "focusdir,down"
    ++ dispatch {} "Down,3" "focusdir,up"
    # 4-finger: Workspace navigation (right drag -> previous tag, left drag -> next)
    ++ dispatch {} "Left,4" "viewtoright_have_client"
    ++ dispatch {} "Right,4" "viewtoleft_have_client"
    ++ dispatch {} "Up,4" "toggleoverview"
    ++ dispatch {} "Down,4" "toggleoverview";

  # Keymodes (submaps) for modal keybindings
  keymode = {
    resize = {
      bind =
        dispatch {} "H" "resizewin,-10,0"
        ++ dispatch {} "J" "resizewin,0,-10"
        ++ dispatch {} "K" "resizewin,0,+10"
        ++ dispatch {} "L" "resizewin,+10,0"
        ++ dispatch {} "Escape" "setkeymode,default";
    };
  };
}
