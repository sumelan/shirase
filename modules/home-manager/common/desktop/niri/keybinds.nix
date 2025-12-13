{lib, ...}: let
  inherit (lib.custom.colors) orange_bright;
  inherit (lib.custom.niri) spawn-sh hotkey;
  selectWindow =
    # sh
    ''
      niri msg action set-dynamic-cast-window --id $(niri msg --json pick-window | jq .id)
    '';
  setMonitor =
    # sh
    ''
      niri msg action set-dynamic-cast-monitor
    '';
  clearTarget =
    # sh
    ''
      niri msg action clear-dynamic-cast-target
    '';
in {
  programs.niri.settings.binds = {
    # shows a list of important hotkeys
    "Mod+Shift+Slash".action.show-hotkey-overlay = {};

    # overview
    "Mod+O".action.toggle-overview = {};

    # exit niri
    "Mod+Shift+Escape".action.quit.skip-confirmation = false;

    # dynamic-cast
    "Mod+Bracketright" = {
      action.spawn = spawn-sh selectWindow;
      hotkey-overlay.title = hotkey {
        color = orange_bright;
        name = "󰗢  Dynamic-cast";
        text = "select window to cast";
      };
    };
    "Mod+Shift+Bracketright" = {
      action.spawn = spawn-sh setMonitor;
      hotkey-overlay.title = hotkey {
        color = orange_bright;
        name = "󰗢  Dynamic-cast";
        text = "set current monitor to cast";
      };
    };
    "Mod+Alt+Bracketright" = {
      action.spawn = spawn-sh clearTarget;
      hotkey-overlay.title = hotkey {
        color = orange_bright;
        name = "󰗢  Dynamic-cast";
        text = "clear cast target";
      };
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

    # use h, j, k ,l keys like vim
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

    # arrow keys
    "Mod+Left".action.consume-or-expel-window-left = {};
    "Mod+Down".action.focus-workspace-down = {};
    "Mod+Up".action.focus-workspace-up = {};
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
    "Mod+WheelScrollDown".action.focus-workspace-down = {};
    "Mod+WheelScrollUp".action.focus-workspace-up = {};
    "Mod+Shift+WheelScrollDown".action.move-column-to-workspace-down = {};
    "Mod+Shift+WheelScrollUp".action.move-column-to-workspace-up = {};

    "Mod+WheelScrollLeft".action.move-column-left = {};
    "Mod+WheelScrollRight".action.move-column-right = {};
    "Mod+Shift+WheelScrollLeft".action.consume-or-expel-window-left = {};
    "Mod+Shift+WheelScrollRight".action.consume-or-expel-window-right = {};

    # mouse click
    "Mod+MouseForward".action.consume-or-expel-window-left = {};
    "Mod+MouseBack".action.consume-or-expel-window-right = {};
    "Mod+MouseMiddle".action.toggle-overview = {};

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
