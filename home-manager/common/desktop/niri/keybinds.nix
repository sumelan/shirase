{ config, user, ... }:
{
  programs.niri.settings.binds =
    with config.lib.niri.actions;
    let
      sh = spawn "sh" "-c";
    in
    {
      # shows a list of important hotkeys.
      "Mod+Shift+Slash".action = show-hotkey-overlay;

      # applications
      "Mod+Return" = {
        action = spawn "kitty";
        hotkey-overlay.title = "Kitty";
      };
      "Mod+E" = {
        action = spawn "nautilus";
        hotkey-overlay.title = "Nautilus";
      };
      "Mod+Shift+E" = {
        action = spawn "kitty" "--app-id" "yazi" "yazi";
        hotkey-overlay.title = "Yazi";
      };
      "Mod+B" = {
        action = spawn "librewolf";
        hotkey-overlay.title = "Librewolf";
      };
      "Mod+C" = {
        action = spawn "kitty" "--app-id" "cava" "cava";
        hotkey-overlay.title = "Cava";
      };
      "Mod+R" = {
        action =
          spawn "kitty" "-T" "󱘗 Rusty Music Player Client" "-o" "font_family=Maple Mono NF" "-o"
            "font_size=12"
            "--app-id"
            "rmpc"
            "rmpc";
        hotkey-overlay.title = "Rusty Music Player Client";
      };
      "Mod+Y" = {
        action = spawn "youtube-music";
        hotkey-overlay.title = "YouTube Music";
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
        action = sh "cd /home/${user}/projects/wolborg && kitty nvim";
        hotkey-overlay.title = "Edit Config";
      };

      # screenlock
      "Mod+Escape" = {
        action = spawn "hyprlock";
        hotkey-overlay.title = "Screenlock";
        # usefull when screen-locker crashed
        allow-when-locked = true;
      };

      # exit niri
      "Mod+Shift+Escape" = {
        action = quit { skip-confirmation = false; };
      };

      # screenshot
      "Mod+Backslash".action = screenshot { show-pointer = false; };
      "Mod+Alt+Backslash".action = screenshot-window { write-to-disk = true; };

      # overview
      "Mod+Shift+Tab".action = toggle-overview;

      # Screencast
      "Mod+Shift+R" = {
        action = spawn "screencast";
        hotkey-overlay.title = "Record Screen";
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

      #NOTE: mediakey binds is written in swayosd.nix
    };
}
