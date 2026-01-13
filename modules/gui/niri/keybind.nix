{config, ...}: let
  inherit
    (config.flake.lib.colors)
    green_bright
    cyan_bright
    magenta_dim
    magenta_bright
    orange_dim
    orange_bright
    blue1
    blue2
    yellow_dim
    ;
  inherit (config.flake.lib) hotkey;
  dms = text:
    hotkey {
      color = magenta_dim;
      name = "󰮤  DankMaterialShell";
      inherit text;
    };
  kitty = hotkey {
    color = green_bright;
    name = "  Kitty";
    text = "Terminal Emulator";
  };
  librewolf = hotkey {
    color = blue2;
    name = "  Librewolf";
    text = "Web Browser";
  };
  nautilus = hotkey {
    color = cyan_bright;
    name = "  Nautilus";
    text = "File Manager";
  };
  vesktop = hotkey {
    color = magenta_bright;
    name = "  Vesktop";
    text = "Discrod Client";
  };
  nix-search-tv = hotkey {
    color = blue1;
    name = "󱄅  nix-search-tv";
    text = "Nix Fuzzey Search";
  };
  yazi = hotkey {
    color = yellow_dim;
    name = "󰇥  yazi";
    text = "Terminal File Manager";
  };
  dynamicCast = text:
    hotkey {
      color = orange_bright;
      name = "󰗢  Dynamic-cast";
      inherit text;
    };
  fcitx = hotkey {
    color = orange_dim;
    name = "  Fcitx";
    text = "Switch Hazkey";
  };
in {
  flake.modules.homeManager.default = _: {
    xdg.configFile."niri/binds.kdl".text =
      # kdl
      ''
        binds {
            // DMS
            Mod+Space hotkey-overlay-title="${dms "Launcher"}" { spawn "dms" "ipc" "call" "spotlight" "toggle"; }
            Mod+Y hotkey-overlay-title="${dms "Clipboard"}" { spawn "dms" "ipc" "call" "clipboard" "toggle"; }
            Mod+X hotkey-overlay-title="${dms "Powermenu"}" { spawn "dms" "ipc" "call" "powermenu" "toggle"; }
            Mod+P hotkey-overlay-title="${dms "Notepad"}" { spawn "dms" "ipc" "call" "notepad" "toggle"; }
            Mod+D hotkey-overlay-title="${dms "Dashboard"}" { spawn "dms" "ipc" "call" "dash" "toggle" "overview"; }
            Mod+W hotkey-overlay-title="${dms "Wallpaper"}" { spawn "dms" "ipc" "call" "dankdash" "wallpaper"; }
            Mod+N hotkey-overlay-title="${dms "Notifications"}" { spawn "dms" "ipc" "call" "notifications" "toggle"; }
            Mod+I hotkey-overlay-title="${dms "Idle-inhibitor"}" { spawn "dms" "ipc" "call" "inhibit" "toggle"; }
            Mod+Alt+N hotkey-overlay-title="${dms "Nightmode"}" { spawn "dms" "ipc" "call" "night" "toggle"; }
            Mod+Slash hotkey-overlay-title="${dms "Show/Hide"}" { spawn "dms" "ipc" "call" "bar" "toggle" "name" "Main Bar"; }
            Mod+Backslash hotkey-overlay-title="${dms "Interactive Screen-capture"}" { spawn "dms" "ipc" "call" "niri" "screenshot"; }
            Mod+Shift+Backslash hotkey-overlay-title="${dms "Capture entire screen"}" { spawn "dms" "ipc" "call" "niri" "screenshotScreen"; }
            Mod+Alt+Backslash hotkey-overlay-title="${dms "Capture focused window"}" { spawn "dms" "ipc" "call" "niri" "screenshotWindow"; }
            Mod+Alt+L allow-when-locked=true hotkey-overlay-title="${dms "Screen-lock"}" { spawn "dms" "ipc" "call" "lock" "lock"; }

            XF86AudioLowerVolume allow-when-locked=true { spawn "dms" "ipc" "call" "audio" "decrement" "3"; }
            XF86AudioMicMute allow-when-locked=true { spawn "dms" "ipc" "call" "audio" "micmute"; }
            XF86AudioMute allow-when-locked=true { spawn "dms" "ipc" "call" "audio" "mute"; }
            XF86AudioNext allow-when-locked=true { spawn "dms" "ipc" "call" "mpris" "next"; }
            XF86AudioPlay allow-when-locked=true { spawn "dms" "ipc" "call" "mpris" "playPause"; }
            XF86AudioPrev allow-when-locked=true { spawn "dms" "ipc" "call" "mpris" "previous"; }
            XF86AudioRaiseVolume allow-when-locked=true { spawn "dms" "ipc" "call" "audio" "increment" "3"; }
            XF86MonBrightnessDown allow-when-locked=true { spawn "dms" "ipc" "call" "brightness" "decrement" "5" ""; }
            XF86MonBrightnessUp allow-when-locked=true { spawn "dms" "ipc" "call" "brightness" "increment" "5" ""; }

            // Execute
            Mod+Return hotkey-overlay-title="${kitty}" { spawn "kitty"; }
            Mod+B hotkey-overlay-title="${librewolf}" { spawn "librewolf"; }
            Mod+E hotkey-overlay-title="${nautilus}" { spawn "nautilus"; }
            Mod+V hotkey-overlay-title="${vesktop}" { spawn "vesktop"; }
            Mod+Shift+E hotkey-overlay-title="${yazi}" { spawn "kitty" "--app-id" "yazi" "yazi"; }
            Mod+Shift+N hotkey-overlay-title="${nix-search-tv}" { spawn "kitty" "--app-id" "nix" "ns"; }
            Mod+Bracketright hotkey-overlay-title="${dynamicCast "Select window as cast target"}" { spawn "sh" "-c" "niri msg action set-dynamic-cast-window --id $(niri msg --json pick-window | jq .id)"; }
            Mod+Shift+Bracketright hotkey-overlay-title="${dynamicCast "Set current output as cast target"}" { spawn "sh" "-c" "niri msg action set-dynamic-cast-monitor"; }
            Mod+Alt+Bracketright hotkey-overlay-title="${dynamicCast "Clear cast target"}" { spawn "sh" "-c" "niri msg action clear-dynamic-cast-target"; }
            Ctrl+Space hotkey-overlay-title="${fcitx}" { spawn "sh" "-c" "fcitx5-remote -t && swayosd-client --custom-message=$(fcitx5-remote -n) --custom-icon=input-keyboard"; }

            // Workspace
            Mod+Down { focus-workspace-down; }
            Mod+Up { focus-workspace-up; }
            Mod+WheelScrollDown { focus-workspace-down; }
            Mod+WheelScrollUp { focus-workspace-up; }
            Mod+TouchpadScrollDown { focus-workspace-down; }
            Mod+TouchpadScrollUp { focus-workspace-up; }
            Mod+Shift+J { move-window-down-or-to-workspace-down; }
            Mod+Shift+K { move-window-up-or-to-workspace-up; }
            Mod+Shift+WheelScrollDown hotkey-overlay-title=null { move-column-to-workspace-down; }
            Mod+Shift+WheelScrollUp hotkey-overlay-title=null { move-column-to-workspace-up; }
            Mod+Shift+TouchpadScrollDown { move-column-to-workspace-down; }
            Mod+Shift+TouchpadScrollUp { move-column-to-workspace-up; }
            Mod+1 { focus-workspace 1; }
            Mod+2 { focus-workspace 2; }
            Mod+3 { focus-workspace 3; }
            Mod+Shift+1 { move-column-to-workspace 1; }
            Mod+Shift+2 { move-column-to-workspace 2; }
            Mod+Shift+3 { move-column-to-workspace 3; }

            // Window
            Mod+Backspace { close-window; }
            Mod+S { switch-focus-between-floating-and-tiling; }
            Mod+F { toggle-window-floating; }
            Mod+Shift+F { fullscreen-window; }
            Mod+Alt+F { toggle-windowed-fullscreen; }
            Mod+C { center-column; }
            Mod+Shift+C { maximize-column; }
            Mod+Ctrl+C { switch-preset-column-width; }
            Mod+T { toggle-column-tabbed-display; }
            Mod+H { focus-column-or-monitor-left; }
            Mod+J { focus-window-or-workspace-down; }
            Mod+K { focus-window-or-workspace-up; }
            Mod+L { focus-column-or-monitor-right; }
            Mod+WheelScrollLeft hotkey-overlay-title=null { focus-column-left; }
            Mod+WheelScrollRight hotkey-overlay-title=null { focus-column-right; }
            Mod+TouchpadScrollLeft { focus-column-left; }
            Mod+TouchpadScrollRight { focus-column-right; }
            Mod+Shift+H { move-column-left-or-to-monitor-left; }
            Mod+Shift+L { move-column-right-or-to-monitor-right; }
            Mod+Shift+TouchpadScrollLeft hotkey-overlay-title=null { move-column-left; }
            Mod+Shift+TouchpadScrollRight hotkey-overlay-title=null { move-column-right; }
            Mod+Ctrl+H { set-column-width "-10%"; }
            Mod+Ctrl+J { set-window-height "+10%"; }
            Mod+Ctrl+K { set-window-height "-10%"; }
            Mod+Ctrl+L { set-column-width "+10%"; }
            Mod+Left { consume-or-expel-window-left; }
            Mod+Right { consume-or-expel-window-right; }
            Mod+Shift+WheelScrollLeft hotkey-overlay-title=null { consume-or-expel-window-left; }
            Mod+Shift+WheelScrollRight hotkey-overlay-title=null { consume-or-expel-window-right; }
            Mod+MouseForward { consume-or-expel-window-left; }
            Mod+MouseBack { consume-or-expel-window-right; }

            // System
            Mod+Shift+Escape { quit skip-confirmation=false; }

            // Overview
            Mod+Shift+Slash { show-hotkey-overlay; }
            Mod+O { toggle-overview; }
        }
      '';
  };
}
