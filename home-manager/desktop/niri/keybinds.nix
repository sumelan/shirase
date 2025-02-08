{
  lib,
  config,
  ...
}:
lib.mkIf config.custom.niri.enable {
  programs.niri.settings.binds = with config.lib.niri.actions; {
    # shows a list of important hotkeys.
    "Mod+Shift+F1".action = show-hotkey-overlay;

    # base apps
    "Mod+Return".action = spawn "kitty";
    "Mod+D".action = spawn "rofi -show drun";
    "Mod+E".action = spawn "nemo";
    "Mod+Shift+E".action = spawn "kitty" "yazi";
    "Mod+B".action = spawn "brave";

    # clipboard
    "Mod+Ctrl+V".action = spawn "cliphist" "list" "rofi" "-dmenu" "cliphist" "decode" "wl-copy";

    #window and colum management
    "Mod+Q".action = close-window;

    "Mod+Alt+F".action = maximize-column;
    "Mod+Alt+C".action = center-column;
    "Mod+F".action = fullscreen-window;
    "Mod+Shift+C".action = switch-preset-column-width;

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

    "Mod+Alt+Semicolon".action = switch-preset-column-width;
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

    # scripts
    "Mod+W".action = spawn "create_or_focus_workspace";
    "Mod+R".action = spawn "rename_workspace";
    
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
      action  = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.5+";
      allow-when-locked = true; # work even when the session is locked
    };
    "XF86AudioLowerVolume" = {
      action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.5-";
      allow-when-locked = true;
    };
    "XF86AudioMute" = {
      action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle";
      allow-when-locked = true;
    };
    "XF86AudioMicMute" = {
      action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle";
      allow-when-locked = true;
    };

    # brightnes
    "XF86MonBrightnessUp" = {
      action = spawn "brightnessctl" "set" "10%+";    
      allow-when-locked = true;
    };
    "XF86MonBrightnessDown" = {
      action = spawn "brightnessctl" "set" "10%-";
      allow-when-locked = true;
    };
  };
}
