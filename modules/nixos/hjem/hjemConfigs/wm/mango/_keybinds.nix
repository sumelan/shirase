_: {
  bind =
    # Dispatchers
    # Window Management
    [
      "SUPER,Backspace,killclient"

      "SUPER,F,togglemaximizescreen" # Maximize window (keep decoration/bar)
      "SUPER+SHIFT,F,togglefullscreen" # Toggle fullscreen
      "SUPER+ALT,F,togglefakefullscreen" # Toggle "fake" fullscreen (remains constrained)

      "SUPER,T,togglefloating" # Toggle floating state
      "SUPER,C,centerwin" # Center the floating window

      "SUPER,G,toggleglobal" # Pin window to all tags

      "SUPER,i,minimized" # Minimize window to scratchpad.
      "ALT,Z,toggle_scratchpad" # Toggle scratchpad
      # Restore minimized window to its previous state.
      # 1 means keep previous tags, 0 means restore to current tags.
      "SUPER+SHIFT,i,restore_minimized,0"

      "SUPER+SHIFT,R,switch_layout" # Cycle through available layouts

      "SUPER,O,toggleoverview" # Toggle overview mode

      "ALT,F4,quit" # exit mango
    ]
    # Focus & Movement
    ++ [
      # Focus window in direction
      "SUPER,H,focusdir,left"
      "SUPER,J,focusdir,down"
      "SUPER,K,focusdir,up"
      "SUPER,L,focusdir,right"

      # Swap window with neighbor in direction
      "SUPER+SHIFT,H,exchange_client,left"
      "SUPER+SHIFT,J,exchange_client,down"
      "SUPER+SHIFT,K,exchange_client,up"
      "SUPER+SHIFT,L,exchange_client,right"

      # Open or cycle the thumbnail switcher.
      "SUPER,S,switcher,next"
      "SUPER+SHIFT,S,switcher,all_tag_next"
    ]
    # Tags & Monitors
    ++ [
      "SUPER,1,view,1"
      "SUPER,2,view,2"
      "SUPER,3,view,3"
      "SUPER,4,view,4"
      "SUPER,5,view,5"
      "SUPER,6,view,6"
      "SUPER,7,view,7"
      "SUPER,8,view,8"
      "SUPER,9,view,9"

      "SUPER+SHIFT,1,tag,1"
      "SUPER+SHIFT,2,tag,2"
      "SUPER+SHIFT,3,tag,3"
      "SUPER+SHIFT,4,tag,4"
      "SUPER+SHIFT,5,tag,5"
      "SUPER+SHIFT,6,tag,6"
      "SUPER+SHIFT,7,tag,7"
      "SUPER+SHIFT,8,tag,8"
      "SUPER+SHIFT,9,tag,9"
    ]
    # Execute
    ++ [
      "SUPER,Return,spawn,footclient"
      "SUPER+SHIFT,Return,spawn,footclient --app-id app.nvim nvim"
      "SUPER+SHIFT,N,spawn,footclient --app-id app.ns ns"
      "SUPER+SHIFT,Y,spawn,footclient --app-id app.yazi yazi"
      "SUPER,B,spawn,brave-origin"

      "SUPER,Space,spawn,noctalia msg panel-toggle launcher"
      "SUPER,Y,spawn,noctalia msg panel-toggle clipboard"
      "SUPER,Comma,spawn,noctalia msg settings-toggle"
      "SUPER,W,spawn,noctalia msg panel-toggle wallpaper"
      "SUPER+SHIFT,W,spawn,noctalia msg panel-toggle noctalia/mpvpaper:picker"
      "SUPER,X,spawn,noctalia msg panel-toggle session"
    ]
    # misc.
    ++ [
      "NONE,Print,spawn,noctalia msg screenshot-region"
      "SHIFT,Print,spawn,noctalia msg screenshot-fullscreen pick"

      "CTRL,Space,spawn,fcitx5-remote -t"
    ]
    # setKeymode
    ++ [
      "ALT,R,setkeymode,resize" # Enter resize mode
    ];

  # Allow when locked
  bindl = [
    "NONE,XF86AudioRaiseVolume,spawn,noctalia msg volume-up"
    "NONE,XF86AudioLowerVolume,spawn,noctalia msg volume-down"
    "NONE,XF86AudioMute,spawn,noctalia msg volume-mute"
    "NONE,XF86AudioPlay,spawn,noctalia msg media toggle"
    "NONE,XF86AudioPrev,spawn,noctalia msg media previous"
    "NONE,XF86AudioNext,spawn,noctalia msg media next"
    "NONE,XF86MonBrightnessUp,spawn,noctalia msg brightness-up"
    "NONE,XF86MonBrightnessDown,spawn,noctalia msg brightness-down"
  ];

  gesturebind = [
    "NONE,Left,3,focusdir,right"
    "NONE,right,3,focusdir,left"
    "NONE,up,3,focusdir,down"
    "NONE,down,3,focusdir,up"
  ];

  # Keymodes (submaps) for modal keybindings
  keymode = {
    resize = {
      bind = [
        "NONE,Left,resizewin,-10,0"
        "NONE,Escape,setkeymode,default"
      ];
    };
  };
}
