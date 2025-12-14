{lib, ...}: let
  inherit
    (lib.custom.colors)
    cyan_dim
    magenta_dim
    orange_base
    orange_bright
    blue0
    blue1
    blue2
    yellow_bright
    red_base
    ;
in {
  xdg.configFile."niri/binds.kdl".text =
    # kdl
    ''
      binds {
          Mod+Shift+Slash { show-hotkey-overlay; }
          Mod+Shift+Escape { quit skip-confirmation=false; }
          Mod+Backspace { close-window; }

          Mod+S { switch-focus-between-floating-and-tiling; }

          Mod+F { toggle-window-floating; }
          Mod+Shift+F { fullscreen-window; }
          Mod+Alt+F { toggle-windowed-fullscreen; }

          Mod+C { center-column; }
          Mod+Shift+C { maximize-column; }
          Mod+Ctrl+C { switch-preset-column-width; }

          Mod+O { toggle-overview; }
          Mod+T { toggle-column-tabbed-display; }

          Mod+1 { focus-workspace 1; }
          Mod+2 { focus-workspace 2; }
          Mod+3 { focus-workspace 3; }
          Mod+Shift+1 { move-column-to-workspace 1; }
          Mod+Shift+2 { move-column-to-workspace 2; }
          Mod+Shift+3 { move-column-to-workspace 3; }

          Mod+H { focus-column-left; }
          Mod+J { focus-window-down; }
          Mod+K { focus-window-up; }
          Mod+L { focus-column-right; }
          Mod+Shift+H { move-column-left; }
          Mod+Shift+J { move-window-down-or-to-workspace-down; }
          Mod+Shift+K { move-window-up-or-to-workspace-up; }
          Mod+Shift+L { move-column-right; }
          Mod+Ctrl+H { set-column-width "-10%"; }
          Mod+Ctrl+J { set-window-height "+10%"; }
          Mod+Ctrl+K { set-window-height "-10%"; }
          Mod+Ctrl+L { set-column-width "+10%"; }

          Mod+Left { consume-or-expel-window-left; }
          Mod+Down { focus-workspace-down; }
          Mod+Up { focus-workspace-up; }
          Mod+Right { consume-or-expel-window-right; }

          Mod+MouseBack { consume-or-expel-window-right; }
          Mod+MouseForward { consume-or-expel-window-left; }
          Mod+MouseMiddle { toggle-overview; }

          Mod+Shift+TouchpadScrollLeft hotkey-overlay-title=null { move-column-left; }
          Mod+Shift+TouchpadScrollDown hotkey-overlay-title=null { move-column-to-workspace-down; }
          Mod+Shift+TouchpadScrollUp hotkey-overlay-title=null { move-column-to-workspace-up; }
          Mod+Shift+TouchpadScrollRight hotkey-overlay-title=null { move-column-right; }

          Mod+WheelScrollLeft { move-column-left; }
          Mod+WheelScrollDown { focus-workspace-down; }
          Mod+WheelScrollUp { focus-workspace-up; }
          Mod+WheelScrollRight { move-column-right; }
          Mod+Shift+WheelScrollLeft { consume-or-expel-window-left; }
          Mod+Shift+WheelScrollDown { move-column-to-workspace-down; }
          Mod+Shift+WheelScrollUp { move-column-to-workspace-up; }
          Mod+Shift+WheelScrollRight { consume-or-expel-window-right; }

          Mod+TouchpadScrollLeft hotkey-overlay-title=null { focus-column-left; }
          Mod+TouchpadScrollDown hotkey-overlay-title=null { focus-workspace-down; }
          Mod+TouchpadScrollUp hotkey-overlay-title=null { focus-workspace-up; }
          Mod+TouchpadScrollRight hotkey-overlay-title=null { focus-column-right; }

          Mod+Return hotkey-overlay-title="<span foreground=\"${blue2}\">[󱙝  Ghostty]</span> Terminal Emulator" { spawn "ghostty"; }
          Mod+B hotkey-overlay-title="<span foreground=\"${blue2}\">[  Librewolf]</span> Web Browser" { spawn "librewolf"; }
          Mod+E hotkey-overlay-title="<span foreground=\"${blue2}\">[󱗆  Euphonica]</span> GTK4 libadwaita MPD Client" { spawn "euphonica"; }
          Mod+V hotkey-overlay-title="<span foreground=\"${blue1}\">[  Vesktop]</span> Discord Client" { spawn "vesktop"; }
          Mod+Shift+N hotkey-overlay-title="<span foreground=\"${blue0}\">[󱄅  nix-search-tv]</span> Nix Fuzzey Search" { spawn "ghostty" "-e" "ns"; }
          Mod+Shift+O hotkey-overlay-title="<span foreground=\"${yellow_bright}\">[  yazi]</span> Terminal File Manager" { spawn "ghostty" "-e" "yazi"; }
          Mod+Shift+R hotkey-overlay-title="<span foreground=\"${orange_base}\">[  rmpc]</span> Terminal MPD Client" { spawn "ghostty" "-e" "rmpc"; }
          Mod+Shift+Y hotkey-overlay-title="<span foreground=\"${red_base}\">[  youtube-tui]</span> Terminal YouTube Client" { spawn "ghostty" "-e" "youtube-tui"; }

          Ctrl+Space hotkey-overlay-title="<span foreground=\"${cyan_dim}\">[  Fcitx5]</span> Switch Mozc" { spawn "sh" "-c" "fcitx5-remote -t && swayosd-client --custom-message=$(fcitx5-remote -n) --custom-icon=input-keyboard"; }

          Mod+Shift+Bracketright hotkey-overlay-title="<span foreground=\"${orange_bright}\">[󰗢  Dynamic-cast]</span> set current monitor to cast" { spawn "sh" "-c" "niri msg action set-dynamic-cast-monitor\n"; }
          Mod+Alt+Bracketright hotkey-overlay-title="<span foreground=\"${orange_bright}\">[󰗢  Dynamic-cast]</span> clear cast target" { spawn "sh" "-c" "niri msg action clear-dynamic-cast-target\n"; }
          Mod+Bracketright hotkey-overlay-title="<span foreground=\"${orange_bright}\">[󰗢  Dynamic-cast]</span> select window to cast" { spawn "sh" "-c" "niri msg action set-dynamic-cast-window --id $(niri msg --json pick-window | jq .id)\n"; }

          Mod+Space hotkey-overlay-title="<span foreground=\"${magenta_dim}\">[󰮤  DankMaterialShell]</span> Launcher" { spawn "dms" "ipc" "call" "spotlight" "toggle"; }
          Mod+W hotkey-overlay-title="<span foreground=\"${magenta_dim}\">[󰮤  DankMaterialShell]</span> Wallpapers" { spawn "dms" "ipc" "call" "dankdash" "wallpaper"; }
          Mod+Y hotkey-overlay-title="<span foreground=\"${magenta_dim}\">[󰮤  DankMaterialShell]</span> Clipboard" { spawn "dms" "ipc" "call" "clipboard" "toggle"; }
          Mod+X hotkey-overlay-title="<span foreground=\"${magenta_dim}\">[󰮤  DankMaterialShell]</span> Power Menu" { spawn "dms" "ipc" "call" "powermenu" "toggle"; }
          Mod+Shift+Backslash hotkey-overlay-title="<span foreground=\"${magenta_dim}\">[󰮤  DankMaterialShell]</span> Capture entire screen" { spawn "dms" "ipc" "call" "niri" "screenshotScreen"; }
          Mod+Alt+Backslash hotkey-overlay-title="<span foreground=\"${magenta_dim}\">[󰮤  DankMaterialShell]</span> Capture focused window" { spawn "dms" "ipc" "call" "niri" "screenshotWindow"; }
          Mod+Alt+L hotkey-overlay-title="<span foreground=\"${magenta_dim}\">[󰮤  DankMaterialShell]</span> Lock Screen" { spawn "dms" "ipc" "call" "lock" "lock"; }
          Mod+Alt+N hotkey-overlay-title="<span foreground=\"${magenta_dim}\">[󰮤  DankMaterialShell]</span> Night Mode" { spawn "dms" "ipc" "call" "night" "toggle"; }
          Mod+P hotkey-overlay-title="<span foreground=\"${magenta_dim}\">[󰮤  DankMaterialShell]</span> Notepad" { spawn "dms" "ipc" "call" "notepad" "toggle"; }
          Mod+D hotkey-overlay-title="<span foreground=\"${magenta_dim}\">[󰮤  DankMaterialShell]</span> Dashboard" { spawn "dms" "ipc" "call" "dash" "toggle" "overview"; }
          Mod+M hotkey-overlay-title="<span foreground=\"${magenta_dim}\">[󰮤  DankMaterialShell]</span> Processlist" { spawn "dms" "ipc" "call" "processlist" "toggle"; }
          Mod+N hotkey-overlay-title="<span foreground=\"${magenta_dim}\">[󰮤  DankMaterialShell]</span> Notifications" { spawn "dms" "ipc" "call" "notifications" "toggle"; }
          Mod+I hotkey-overlay-title="<span foreground=\"${magenta_dim}\">[󰮤  DankMaterialShell]</span> Idle Inhibitor" { spawn "dms" "ipc" "call" "inhibit" "toggle"; }
          Mod+Backslash hotkey-overlay-title="<span foreground=\"${magenta_dim}\">[󰮤  DankMaterialShell]</span> Interactive Screen-capture" { spawn "dms" "ipc" "call" "niri" "screenshot"; }
          Mod+Comma hotkey-overlay-title="<span foreground=\"${magenta_dim}\">[󰮤  DankMaterialShell]</span> Settings" { spawn "dms" "ipc" "call" "settings" "toggle"; }

          XF86AudioLowerVolume allow-when-locked=true { spawn "dms" "ipc" "call" "audio" "decrement" "3"; }
          XF86AudioMicMute allow-when-locked=true { spawn "dms" "ipc" "call" "audio" "micmute"; }
          XF86AudioMute allow-when-locked=true { spawn "dms" "ipc" "call" "audio" "mute"; }
          XF86AudioNext allow-when-locked=true { spawn "dms" "ipc" "call" "mpris" "next"; }
          XF86AudioPlay allow-when-locked=true { spawn "dms" "ipc" "call" "mpris" "playPause"; }
          XF86AudioPrev allow-when-locked=true { spawn "dms" "ipc" "call" "mpris" "previous"; }
          XF86AudioRaiseVolume allow-when-locked=true { spawn "dms" "ipc" "call" "audio" "increment" "3"; }
          XF86MonBrightnessDown allow-when-locked=true { spawn "dms" "ipc" "call" "brightness" "decrement" "5" ""; }
          XF86MonBrightnessUp allow-when-locked=true { spawn "dms" "ipc" "call" "brightness" "increment" "5" ""; }

      }
    '';
}
