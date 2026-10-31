_: {
  binds = let
    hotkey = color: name: text: ''<span foreground='${color}'>[${name}]</span> ${text}'';
  in {
    "Mod+Space" = {
      _props.hotkey-overlay-title = hotkey "#babbf1" "󰮤  Dux Shell" "Spotlight";
      spawn = ["dms" "ipc" "call" "spotlight-bar" "toggle"];
    };
    "Mod+Y" = {
      _props.hotkey-overlay-title = hotkey "#babbf1" "󰮤  Dux Shell" "Clipboard";
      spawn = ["dms" "ipc" "call" "clipboard" "toggle"];
    };
    "Mod+W" = {
      _props.hotkey-overlay-title = hotkey "#babbf1" "󰮤  Dux Shell" "Wallpaper Carousel";
      spawn = ["dms" "ipc" "wallpaperCarousel" "toggle"];
    };
    "Mod+X" = {
      _props.hotkey-overlay-title = hotkey "#babbf1" "󰮤  Dux Shell" "Powermenu";
      spawn = ["dms" "ipc" "call" "powermenu" "toggle"];
    };
    "Mod+Comma" = {
      _props.hotkey-overlay-title = hotkey "#babbf1" "󰮤  Dux Shell" "Settings";
      spawn = ["dms" "ipc" "call" "settings" "toggle"];
    };
    "Print" = {spawn = ["dms" "ipc" "call" "niri" "screenshot"];};
    "Shift+Print" = {spawn = ["dms" "ipc" "call" "niri" "screenshotScreen"];};
    "Alt+Print" = {spawn = ["dms" "ipc" "call" "niri" "screenshotWindow"];};

    # media-key
    "XF86AudioRaiseVolume" = {
      _props.allow-when-locked = true;
      spawn = ["dms" "ipc" "call" "audio" "increment" "5%"];
    };
    "XF86AudioLowerVolume" = {
      _props.allow-when-locked = true;
      spawn = ["dms" "ipc" "call" "audio" "decrement" "5%"];
    };
    "XF86AudioMute" = {
      _props.allow-when-locked = true;
      spawn = ["dms" "ipc" "call" "audio" "mute"];
    };
    "XF86AudioPlay" = {
      _props.allow-when-locked = true;
      spawn = ["dms" "ipc" "call" "mpris" "playPause"];
    };
    "XF86AudioPrev" = {
      _props.allow-when-locked = true;
      spawn = ["dms" "ipc" "call" "mpris" "previous"];
    };
    "XF86AudioNext" = {
      _props.allow-when-locked = true;
      spawn = ["dms" "ipc" "call" "mpris" "next"];
    };
    "XF86MonBrightnessUp" = {
      _props.allow-when-locked = true;
      spawn = ["dms" "ipc" "call" "brightness" "increment" "5%" "software:DP-1"];
    };
    "XF86MonBrightnessDown" = {
      _props.allow-when-locked = true;
      spawn = ["dms" "ipc" "call" "brightness" "decrement" "5%" "software:DP-1"];
    };

    # execute
    "Mod+Return" = {
      _props.hotkey-overlay-title = hotkey "#8caaee" "󰊠  Ghostty" "Terminal Emulator";
      spawn = ["ghostty" "+new-window"];
    };
    "Mod+Shift+Return" = {
      _props.hotkey-overlay-title = hotkey "#a6d189" "  Neovim" "Text Editor";
      spawn = ["ghostty" "--class=app.nvim" "-e" "nvim"];
    };
    "Mod+B" = {
      _props.hotkey-overlay-title = hotkey "#e78284" "  Helium" "Web Browser";
      spawn = ["helium"];
    };
    "Mod+D" = {
      _props.hotkey-overlay-title = hotkey "#ef9f76" "  Dissent" "Discord Client";
      spawn = ["dissent"];
    };
    "Mod+Shift+N" = {
      _props.hotkey-overlay-title = hotkey "#8caaee" "󱄅  Nix Search" "Nix Package";
      spawn = ["ghostty" "--class=app.ns" "-e" "ns"];
    };
    "Mod+Shift+B" = {
      _props.hotkey-overlay-title = hotkey "#e5c890" "󰆚  Broot" "TUI File Manager";
      spawn = ["ghostty" "--class=app.broot" "-e" "broot"];
    };
    "Ctrl+Space" = {
      _props.hotkey-overlay-title = hotkey "#ca9ee6" "󰗊  Meltype" "Switch input method";
      spawn = ["fcitx5-remote" "-t"];
    };

    # window
    "Mod+Backspace" = {
      _props.repeat = false;
      close-window = [];
    };
    "Mod+F" = {maximize-column = [];};
    "Mod+Shift+F" = {fullscreen-window = [];};
    "Mod+Alt+F" = {toggle-windowed-fullscreen = [];};
    "Mod+M" = {maximize-window-to-edges = [];};
    "Mod+T" = {toggle-window-floating = [];};
    "Mod+Shift+T" = {switch-focus-between-floating-and-tiling = [];};
    "Mod+Alt+T" = {toggle-column-tabbed-display = [];};

    # focus
    "Mod+H" = {focus-column-or-monitor-left = [];};
    "Mod+J" = {focus-window-or-workspace-down = [];};
    "Mod+K" = {focus-window-or-workspace-up = [];};
    "Mod+L" = {focus-column-or-monitor-right = [];};
    "Mod+Down" = {focus-monitor-down = [];};
    "Mod+Up" = {focus-monitor-up = [];};

    # move
    "Mod+Shift+H" = {move-column-left = [];};
    "Mod+Shift+J" = {move-window-down-or-to-workspace-down = [];};
    "Mod+Shift+K" = {move-window-up-or-to-workspace-up = [];};
    "Mod+Shift+L" = {move-column-right = [];};
    "Mod+Alt+H" = {move-column-to-monitor-left = [];};
    "Mod+Alt+J" = {move-column-to-monitor-down = [];};
    "Mod+Alt+K" = {move-column-to-monitor-up = [];};
    "Mod+Alt+L" = {move-column-to-monitor-right = [];};

    # column
    "Mod+Home" = {focus-column-first = [];};
    "Mod+End" = {focus-column-last = [];};
    "Mod+Shift+Home" = {move-column-to-first = [];};
    "Mod+Shift+End" = {move-column-to-last = [];};
    "Mod+C" = {center-column = [];};
    "Mod+Alt+C" = {center-visible-columns = [];};
    "Mod+BracketLeft" = {consume-or-expel-window-left = [];};
    "Mod+BracketRight" = {consume-or-expel-window-right = [];};
    "Mod+Period" = {expel-window-from-column = [];};

    # sizing and layout
    "Mod+R" = {switch-preset-column-width = [];};
    "Mod+Shift+R" = {switch-preset-window-height = [];};

    # manual sizing
    "Mod+Minus" = {set-column-width = "-10%";};
    "Mod+Equal" = {set-column-width = "+10%";};
    "Mod+Shift+Minus" = {set-window-height = "-10%";};
    "Mod+Shift+Equal" = {set-window-height = "+10%";};

    # numberred workspaces
    "Mod+1" = {focus-workspace = 1;};
    "Mod+2" = {focus-workspace = 2;};
    "Mod+3" = {focus-workspace = 3;};
    "Mod+4" = {focus-workspace = 4;};
    "Mod+5" = {focus-workspace = 5;};
    "Mod+6" = {focus-workspace = 6;};
    "Mod+7" = {focus-workspace = 7;};
    "Mod+8" = {focus-workspace = 8;};
    "Mod+9" = {focus-workspace = 9;};
    "Mod+Shift+1" = {move-column-to-workspace = 1;};
    "Mod+Shift+2" = {move-column-to-workspace = 2;};
    "Mod+Shift+3" = {move-column-to-workspace = 3;};
    "Mod+Shift+4" = {move-column-to-workspace = 4;};
    "Mod+Shift+5" = {move-column-to-workspace = 5;};
    "Mod+Shift+6" = {move-column-to-workspace = 6;};
    "Mod+Shift+7" = {move-column-to-workspace = 7;};
    "Mod+Shift+8" = {move-column-to-workspace = 8;};
    "Mod+Shift+9" = {move-column-to-workspace = 9;};

    # mouse wheel
    "Mod+WheelScrollDown" = {
      _props.cooldown-ms = 150;
      focus-workspace-down = [];
    };
    "Mod+WheelScrollUp" = {
      _props.cooldown-ms = 150;
      focus-workspace-up = [];
    };
    "Mod+WheelScrollRight" = {
      _props.cooldown-ms = 150;
      focus-column-right = [];
    };
    "Mod+WheelScrollLeft" = {
      _props.cooldown-ms = 150;
      focus-column-left = [];
    };
    "Mod+Shift+WheelScrollDown" = {move-column-to-workspace-down = [];};
    "Mod+Shift+WheelScrollUp" = {move-column-to-workspace-up = [];};
    "Mod+Shift+WheelScrollRight" = {consume-or-expel-window-right = [];};
    "Mod+Shift+WheelScrollLeft" = {consume-or-expel-window-left = [];};

    # touchpad
    "Mod+TouchpadScrollDown" = {focus-workspace-down = [];};
    "Mod+TouchpadScrollUp" = {focus-workspace-up = [];};
    "Mod+TouchpadScrollRight" = {focus-column-right = [];};
    "Mod+TouchpadScrollLeft" = {focus-column-left = [];};
    "Mod+Shift+TouchpadScrollDown" = {move-column-to-workspace-down = [];};
    "Mod+Shift+TouchpadScrollUp" = {move-column-to-workspace-up = [];};
    "Mod+Shift+TouchpadScrollRight" = {move-column-right = [];};
    "Mod+Shift+TouchpadScrollLeft" = {move-column-left = [];};

    # system
    "Mod+Shift+Slash" = {show-hotkey-overlay = [];};
    "Mod+O" = {toggle-overview = [];};
    "Mod+Shift+O" = {toggle-window-rule-opacity = [];};
    "Mod+Shift+Escape" = {
      quit = {_props.skip-confirmation = false;};
    };
    "Mod+Escape" = {
      _props.allow-inhibiting = false;
      toggle-keyboard-shortcuts-inhibit = [];
    };
    "Mod+Shift+P" = {power-off-monitors = [];};
  };
}
