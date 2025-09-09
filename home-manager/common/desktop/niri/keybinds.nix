{
  lib,
  config,
  ...
}: let
  inherit
    (lib.custom.niri)
    runCmd
    ;
in {
  programs.niri.settings.binds = with config.lib.niri.actions; {
    # shows a list of important hotkeys.
    "Mod+Shift+Slash".action = show-hotkey-overlay;

    # overview
    "Mod+Tab".action = toggle-overview;

    # exit niri
    "Mod+Shift+Escape".action = quit {skip-confirmation = false;};

    # screenshot 'screenshot-screen' is valid only on niri-stable
    "Mod+Backslash".action = screenshot {show-pointer = false;};
    "Mod+Shift+Backslash" = runCmd {
      cmd = "niri msg action screenshot-screen";
      title = "Screenshot the focused screen";
    };
    "Mod+Alt+Backslash".action = screenshot-window {write-to-disk = true;};

    # window and colum management
    "Mod+Backspace".action = close-window;

    "Mod+F".action = toggle-window-floating;
    "Mod+Shift+F".action = fullscreen-window;
    "Mod+Ctrl+Shift+F".action = toggle-windowed-fullscreen;

    "Mod+Alt+F".action = maximize-column;
    "Mod+Shift+C".action = switch-preset-column-width;
    "Mod+Alt+C".action = center-column;

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

    "Mod+Left".action = consume-or-expel-window-left;
    "Mod+Right".action = consume-or-expel-window-right;

    # tabbed
    "Mod+T".action = toggle-column-tabbed-display;

    # numbered-workspaces
    "Mod+1" = {
      action.focus-workspace = 1;
      hotkey-overlay.hidden = true;
    };
    "Mod+2" = {
      action.focus-workspace = 2;
      hotkey-overlay.hidden = true;
    };
    "Mod+3" = {
      action.focus-workspace = 3;
      hotkey-overlay.hidden = true;
    };
    "Mod+Shift+1" = {
      action.move-column-to-workspace = 1;
      hotkey-overlay.hidden = true;
    };
    "Mod+Shift+2" = {
      action.move-column-to-workspace = 2;
      hotkey-overlay.hidden = true;
    };
    "Mod+Shift+3" = {
      action.move-column-to-workspace = 3;
      hotkey-overlay.hidden = true;
    };

    # mouse scroll
    "Mod+WheelScrollDown" = {
      action = focus-workspace-down;
      cooldown-ms = 150;
      hotkey-overlay.hidden = true;
    };
    "Mod+WheelScrollUp" = {
      action = focus-workspace-up;
      cooldown-ms = 150;
      hotkey-overlay.hidden = true;
    };
    "Mod+WheelScrollRight" = {
      action = focus-column-right;
      cooldown-ms = 150;
      hotkey-overlay.hidden = true;
    };
    "Mod+WheelScrollLeft" = {
      action = focus-column-left;
      cooldown-ms = 150;
      hotkey-overlay.hidden = true;
    };

    "Mod+Shift+WheelScrollDown" = {
      action = move-column-to-workspace-down;
      cooldown-ms = 150;
      hotkey-overlay.hidden = true;
    };
    "Mod+Shift+WheelScrollUp" = {
      action = move-column-to-workspace-up;
      cooldown-ms = 150;
      hotkey-overlay.hidden = true;
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
