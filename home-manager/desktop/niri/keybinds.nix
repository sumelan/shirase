{
  config,
  dotfiles,
  ...
}:
{
  programs.niri.settings.binds = with config.lib.niri.actions; {
    # shows a list of important hotkeys.
    "Mod+Shift+Slash".action = show-hotkey-overlay;

    # base apps
    "Mod+Return" = {
      action = spawn "kitty";
      hotkey-overlay.title = "Kitty";
    };
    "Mod+E" = {
      action = spawn "nemo";
      hotkey-overlay.title = "Nemo";
    };
    "Mod+Shift+E" = {
      action = spawn "kitty" "yazi";
      hotkey-overlay.title = "Yazi";
    };
    "Mod+B" = {
      action = spawn "librewolf";
      hotkey-overlay.title = "Librewolf";
    };
    "Mod+R" = {
      action = spawn "kitty" "--app-id" "rmpc" "rmpc";
      hotkey-overlay.title = "rmpc";
    };

    # launcher
    "Mod+D" = {
      action = spawn "fuzzel";
      hotkey-overlay.title = "Fuzzel";
    };
    "Mod+Space" = {
      action = spawn "fuzzel-files";
      hotkey-overlay.title = "File Search";
    };
    "Mod+Tab" = {
      action = spawn "fuzzel-windows";
      hotkey-overlay.title = "Windows Search";
    };
    "Mod+Ctrl+Q" = {
      action = spawn "fuzzel-actions";
      hotkey-overlay.title = "System Actions";
    };
    "Mod+Period" = {
      action = spawn "fuzzel-icons";
      hotkey-overlay.title = "Icon Search";
    };

    # neovim
    "Mod+Shift+Return" = {
      action = spawn "kitty" "nvim" "${dotfiles}";
      hotkey-overlay.title = "Edit Config";
    };

    # screenshot
    "Mod+Backslash".action = screenshot;
    "Mod+Shift+Backslash".action = screenshot-screen;
    "Mod+Alt+Backslash".action = screenshot-window;

    # Screencast
    "Mod+Shift+Home" = {
      action = spawn "screencast";
      hotkey-overlay.title = "Screen Record";
    };

    # clipboard
    "Mod+V" = {
      action = spawn "fuzzel-clipboard";
      hotkey-overlay.title = "Show Clipboard History";
    };
    "Mod+Ctrl+V" = {
      action = spawn "rm" "$XDG_CACHE_HOME/cliphist/db";
      hotkey-overlay.title = "Clear Clipboard History";
    };

    # notification
    "Mod+N" = {
      action = spawn "dunstctl" "history-pop";
      hotkey-overlay.title = "Show Notification History";
    };
    "Mod+Shift+N" = {
      action = spawn "dunstctl" "close-all";
      hotkey-overlay.title = "Dismiss Notification";
    };

    # window and colum management
    "Mod+Backspace".action = close-window;

    "Mod+F".action = fullscreen-window;
    "Mod+Alt+F".action = maximize-column;
    "Mod+Shift+F".action = toggle-window-floating;
    "Mod+Shift+C".action = switch-preset-column-width;
    "Mod+Alt+C".action = center-column;

    "Mod+H".action = focus-column-left;
    "Mod+J".action = focus-window-down;
    "Mod+K".action = focus-window-up;
    "Mod+L".action = focus-column-right;

    "Mod+Shift+H".action = move-column-left;
    "Mod+Shift+J".action = move-window-down-or-to-workspace-down;
    "Mod+Shift+K".action = move-window-up-or-to-workspace-up;
    "Mod+Shift+L".action = move-column-right;

    "Mod+Shift+U".action = consume-or-expel-window-left;
    "Mod+Shift+I".action = consume-or-expel-window-right;

    "Mod+Alt+H".action = set-column-width "-10%";
    "Mod+Alt+L".action = set-column-width "+10%";
    "Mod+Alt+J".action = set-window-height "-10%";
    "Mod+Alt+K".action = set-window-height "+10%";

    # workspaces
    "Mod+1".action.focus-workspace = 1;
    "Mod+2".action.focus-workspace = 2;
    "Mod+3".action.focus-workspace = 3;
    "Mod+Shift+1".action.move-column-to-workspace = 1;
    "Mod+Shift+2".action.move-column-to-workspace = 2;
    "Mod+Shift+3".action.move-column-to-workspace = 3;

    # mouse scroll
    "Mod+WheelScrollDown" = {
      action = focus-workspace-down;
      cooldown-ms = 150;
    };
    "Mod+WheelScrollUp" = {
      action = focus-workspace-up;
      cooldown-ms = 150;
    };
    "Mod+Ctrl+WheelScrollDown" = {
      action = move-column-to-workspace-down;
      cooldown-ms = 150;
    };
    "Mod+Ctrl+WheelScrollUp" = {
      action = move-column-to-workspace-up;
      cooldown-ms = 150;
    };
    "Mod+Shift+WheelScrollDown".action = focus-column-right;
    "Mod+Shift+WheelScrollUp".action = focus-column-left;

    # Touchpad gestures
    "Mod+Shift+TouchpadScrollUp".action = move-column-to-workspace-up;
    "Mod+Shift+TouchpadScrollDown".action = move-column-to-workspace-down;
    "Mod+TouchpadScrollUp".action = focus-workspace-up;
    "Mod+TouchpadScrollDown".action = focus-workspace-down;

    "Mod+TouchpadScrollRight".action = focus-column-right;
    "Mod+TouchpadScrollLeft".action = focus-column-left;

    "Mod+Shift+TouchpadScrollRight".action = move-column-right;
    "Mod+Shift+TouchpadScrollLeft".action = move-column-left;

    # audio
    "XF86AudioRaiseVolume" = {
      action = spawn "swayosd-client" "--output-volume" "raise";
      allow-when-locked = true; # work even when the session is locked
    };
    "XF86AudioLowerVolume" = {
      action = spawn "swayosd-client" "--output-volume" "lower";
      allow-when-locked = true;
    };
    "XF86AudioMute" = {
      action = spawn "swayosd-client" "--output-volume" "mute-toggle";
      allow-when-locked = true;
    };
    "XF86AudioMicMute" = {
      action = spawn "swayosd-client" "--input-volume" "mute-toggle";
      allow-when-locked = true;
    };
    "XF86AudioPlay" = {
      action = spawn "playerctl" "play-pause";
      allow-when-locked = true;
    };
    "XF86AudioPause" = {
      action = spawn "playerctl" "play-pause";
      allow-when-locked = true;
    };
    "XF86AudioNext" = {
      action = spawn "playerctl" "next";
      allow-when-locked = true;
    };
    "XF86AudioPrev" = {
      action = spawn "playerctl" "previous";
      allow-when-locked = true;
    };

    # brightness
    "XF86MonBrightnessUp" = {
      action = spawn "swayosd-client" "--brightness" "raise";
      allow-when-locked = true;
    };
    "XF86MonBrightnessDown" = {
      action = spawn "swayosd-client" "--brightness" "lower";
      allow-when-locked = true;
    };
  };
}
