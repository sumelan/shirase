{ config, ... }:
{
  programs.niri.settings.binds =
    with config.lib.niri.actions;
    # let
    # sh = spawn "sh" "-c";
    # in
    {
      # application binds are written in each app.nix

      # shows a list of important hotkeys.
      "Mod+Shift+Slash".action = show-hotkey-overlay;

      # overview
      "Mod+Shift+Tab".action = toggle-overview;

      # exit niri
      "Mod+Shift+Escape".action = quit { skip-confirmation = false; };

      # screenshot NOTE: 'screenshot-screen' is valid only on niri-stable
      "Mod+Backslash".action = screenshot { show-pointer = false; };
      "Mod+Alt+Backslash".action = screenshot-window { write-to-disk = true; };

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

      # acer fn+F3 binds Mod+P
      "Mod+P".action = consume-or-expel-window-left;
      "Mod+Shift+P".action = consume-or-expel-window-right;

      "Mod+Alt+H".action = set-column-width "-10%";
      "Mod+Alt+L".action = set-column-width "+10%";
      "Mod+Alt+J".action = set-window-height "-10%";
      "Mod+Alt+K".action = set-window-height "+10%";

      # workspaces
      "Mod+1".action.focus-workspace = 1;
      "Mod+2".action.focus-workspace = 2;
      "Mod+3".action.focus-workspace = 3;
      "Mod+0".action.focus-workspace = "huion";

      "Mod+Shift+1".action.move-column-to-workspace = 1;
      "Mod+Shift+2".action.move-column-to-workspace = 2;
      "Mod+Shift+3".action.move-column-to-workspace = 3;
      "mod+Shift+0".action.move-column-to-workspace = "huion";

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
      "Mod+TouchpadScrollUp".action = focus-workspace-up;
      "Mod+TouchpadScrollDown".action = focus-workspace-down;
      "Mod+TouchpadScrollRight".action = focus-column-right;
      "Mod+TouchpadScrollLeft".action = focus-column-left;

      "Mod+Shift+TouchpadScrollUp".action = move-column-to-workspace-up;
      "Mod+Shift+TouchpadScrollDown".action = move-column-to-workspace-down;

      "Mod+Shift+TouchpadScrollRight".action = move-column-right;
      "Mod+Shift+TouchpadScrollLeft".action = move-column-left;

      # mediakey binds are written in swayosd.nix
    };
}
