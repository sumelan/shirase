{lib, ...}: let
  inherit (lib.custom.niri) spawn-sh;
  selectWindow =
    # sh
    ''
      niri msg action set-dynamic-cast-window --id $(niri msg --json pick-window | jq .id)
    '';
  setMonitor = ''
    niri msg action set-dynamic-cast-monitor
  '';
  clearTarget = ''
    niri msg action clear-dynamic-cast-target
  '';
in {
  programs.niri.settings.binds = {
    # shows a list of important hotkeys
    "Mod+Shift+Slash".action.show-hotkey-overlay = {};

    # overview
    "Mod+Tab".action.toggle-overview = {};

    # exit niri
    "Mod+Shift+Escape".action.quit.skip-confirmation = false;

    # screenshot
    "Mod+Backslash".action.screenshot.show-pointer = false;
    "Mod+Shift+Backslash".action.screenshot-screen.show-pointer = false;
    "Mod+Alt+Backslash".action.screenshot-window.write-to-disk = true;

    # dynamic-cast
    "Mod+Ctrl+D" = {
      action.spawn = spawn-sh selectWindow;
      hotkey-overlay.title = "select window to cast";
    };
    "Mod+Shift+D" = {
      action.spawn = spawn-sh setMonitor;
      hotkey-overlay.title = "set current monitor to cast";
    };
    "Mod+Alt+D" = {
      action.spawn = spawn-sh clearTarget;
      hotkey-overlay.title = "clear cast target";
    };

    # window and column management
    "Mod+Backspace".action.close-window = {};

    "Mod+F".action.toggle-window-floating = {};
    "Mod+S".action.switch-focus-between-floating-and-tiling = {};

    "Mod+Shift+F".action.fullscreen-window = {};
    "Mod+Alt+F".action.toggle-windowed-fullscreen = {};

    "Mod+C".action.center-column = {};
    "Mod+Shift+C".action.maximize-column = {};
    "Mod+Ctrl+C".action.switch-preset-column-width = {};

    # vim-like
    "Mod+H".action.focus-column-left = {};
    "Mod+J".action.focus-window-down = {};
    "Mod+K".action.focus-window-up = {};
    "Mod+L".action.focus-column-right = {};

    "Mod+Shift+H".action.move-column-left = {};
    "Mod+Shift+J".action.move-window-down-or-to-workspace-down = {};
    "Mod+Shift+K".action.move-window-up-or-to-workspace-up = {};
    "Mod+Shift+L".action.move-column-right = {};

    "Mod+Ctrl+H".action.set-column-width = "-10%";
    "Mod+Ctrl+J".action.set-window-height = "+10%";
    "Mod+Ctrl+K".action.set-window-height = "-10%";
    "Mod+Ctrl+L".action.set-column-width = "+10%";

    # consume or expel
    "Mod+Left".action.consume-or-expel-window-left = {};
    "Mod+Right".action.consume-or-expel-window-right = {};

    # tabbed
    "Mod+T".action.toggle-column-tabbed-display = {};

    # numbered-workspaces
    "Mod+1".action.focus-workspace = 1;
    "Mod+2".action.focus-workspace = 2;
    "Mod+3".action.focus-workspace = 3;
    "Mod+Shift+1".action.move-column-to-workspace = 1;
    "Mod+Shift+2".action.move-column-to-workspace = 2;
    "Mod+Shift+3".action.move-column-to-workspace = 3;

    # mouse wheel
    "Mod+WheelScrollDown" = {
      action.focus-workspace-down = {};
      cooldown-ms = 150;
    };
    "Mod+WheelScrollUp" = {
      action.focus-workspace-up = {};
      cooldown-ms = 150;
    };
    "Mod+WheelScrollRight" = {
      action.focus-column-right = {};
      cooldown-ms = 150;
    };
    "Mod+WheelScrollLeft" = {
      action.focus-column-left = {};
      cooldown-ms = 150;
    };
    "Mod+Shift+WheelScrollDown" = {
      action.move-column-to-workspace-down = {};
      cooldown-ms = 150;
    };
    "Mod+Shift+WheelScrollUp" = {
      action.move-column-to-workspace-up = {};
      cooldown-ms = 150;
    };

    # mouse click
    "Mod+MouseForward".action.consume-or-expel-window-left = {};
    "Mod+MouseBack".action.consume-or-expel-window-right = {};

    # touchpad gestures
    "Mod+TouchpadScrollUp" = {
      action.focus-workspace-up = {};
      hotkey-overlay.hidden = true;
    };
    "Mod+TouchpadScrollDown" = {
      action.focus-workspace-down = {};
      hotkey-overlay.hidden = true;
    };
    "Mod+TouchpadScrollRight" = {
      action.focus-column-right = {};
      hotkey-overlay.hidden = true;
    };
    "Mod+TouchpadScrollLeft" = {
      action.focus-column-left = {};
      hotkey-overlay.hidden = true;
    };
    "Mod+Shift+TouchpadScrollUp" = {
      action.move-column-to-workspace-up = {};
      hotkey-overlay.hidden = true;
    };
    "Mod+Shift+TouchpadScrollDown" = {
      action.move-column-to-workspace-down = {};
      hotkey-overlay.hidden = true;
    };
    "Mod+Shift+TouchpadScrollRight" = {
      action.move-column-right = {};
      hotkey-overlay.hidden = true;
    };
    "Mod+Shift+TouchpadScrollLeft" = {
      action.move-column-left = {};
      hotkey-overlay.hidden = true;
    };
  };
}
