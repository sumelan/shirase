{config, ...}: let
  inherit
    (config.lib.niri.actions)
    spawn
    show-hotkey-overlay
    toggle-overview
    quit
    screenshot
    screenshot-window
    clear-dynamic-cast-target
    close-window
    toggle-window-floating
    fullscreen-window
    toggle-windowed-fullscreen
    maximize-column
    center-column
    switch-preset-column-width
    focus-column-left
    focus-window-down
    focus-window-up
    focus-column-right
    focus-workspace-down
    focus-workspace-up
    move-column-left
    move-window-down-or-to-workspace-down
    move-window-up-or-to-workspace-up
    move-column-right
    move-column-to-workspace-down
    move-column-to-workspace-up
    set-column-width
    set-window-height
    consume-or-expel-window-left
    consume-or-expel-window-right
    toggle-column-tabbed-display
    ;
in {
  programs.niri.settings.binds = {
    # shows a list of important hotkeys
    "Mod+Shift+Slash".action = show-hotkey-overlay;

    # overview
    "Mod+Tab".action = toggle-overview;

    # exit niri
    "Mod+Shift+Escape".action = quit {skip-confirmation = false;};

    # screenshot
    "Mod+Backslash".action = screenshot {show-pointer = false;};
    "Mod+Shift+Backslash".action = screenshot-window {write-to-disk = true;};

    # dynamic screencast target
    "Mod+Alt+Backslash" = {
      action = spawn "sh" "-c" "niri msg action set-dynamic-cast-window --id $(niri msg --json pick-window | jq .id)";
      hotkey-overlay.title = "Interactively pick which window to cast";
    };
    "Mod+Ctrl+Backslash".action = clear-dynamic-cast-target;

    # window and colum management
    "Mod+Backspace".action = close-window;

    "Mod+F".action = toggle-window-floating;
    "Mod+Shift+F".action = fullscreen-window;
    "Mod+Alt+F".action = toggle-windowed-fullscreen;

    "Mod+Ctrl+F".action = maximize-column;
    "Mod+Shift+C".action = center-column;
    "Mod+Ctrl+C".action = switch-preset-column-width;

    # vim-like
    "Mod+H".action = focus-column-left;
    "Mod+J".action = focus-window-down;
    "Mod+K".action = focus-window-up;
    "Mod+L".action = focus-column-right;

    "Mod+Shift+H".action = move-column-left;
    "Mod+Shift+J".action = move-window-down-or-to-workspace-down;
    "Mod+Shift+K".action = move-window-up-or-to-workspace-up;
    "Mod+Shift+L".action = move-column-right;

    "Mod+Ctrl+H".action = set-column-width "-10%";
    "Mod+Ctrl+J".action = set-window-height "+10%";
    "Mod+Ctrl+K".action = set-window-height "-10%";
    "Mod+Ctrl+L".action = set-column-width "+10%";

    # consume or expel
    "Mod+Left".action = consume-or-expel-window-left;
    "Mod+Right".action = consume-or-expel-window-right;

    # tabbed
    "Mod+T".action = toggle-column-tabbed-display;

    # numbered-workspaces
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
    "Mod+WheelScrollRight" = {
      action = focus-column-right;
      cooldown-ms = 150;
    };
    "Mod+WheelScrollLeft" = {
      action = focus-column-left;
      cooldown-ms = 150;
    };

    "Mod+Shift+WheelScrollDown" = {
      action = move-column-to-workspace-down;
      cooldown-ms = 150;
    };
    "Mod+Shift+WheelScrollUp" = {
      action = move-column-to-workspace-up;
      cooldown-ms = 150;
    };

    # Touchpad gestures
    "Mod+TouchpadScrollUp" = {
      action = focus-workspace-up;
      hotkey-overlay.hidden = true;
    };
    "Mod+TouchpadScrollDown" = {
      action = focus-workspace-down;
      hotkey-overlay.hidden = true;
    };
    "Mod+TouchpadScrollRight" = {
      action = focus-column-right;
      hotkey-overlay.hidden = true;
    };
    "Mod+TouchpadScrollLeft" = {
      action = focus-column-left;
      hotkey-overlay.hidden = true;
    };
    "Mod+Shift+TouchpadScrollUp" = {
      action = move-column-to-workspace-up;
      hotkey-overlay.hidden = true;
    };
    "Mod+Shift+TouchpadScrollDown" = {
      action = move-column-to-workspace-down;
      hotkey-overlay.hidden = true;
    };
    "Mod+Shift+TouchpadScrollRight" = {
      action = move-column-right;
      hotkey-overlay.hidden = true;
    };
    "Mod+Shift+TouchpadScrollLeft" = {
      action = move-column-left;
      hotkey-overlay.hidden = true;
    };
  };
}
