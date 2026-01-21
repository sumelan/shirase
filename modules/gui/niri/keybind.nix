{config, ...}: let
  inherit
    (config.flake.lib.colors)
    white3
    green_bright
    cyan_bright
    magenta_dim
    magenta_bright
    blue1
    blue2
    yellow_dim
    orange_bright
    ;
  inherit (config.flake.lib) hotkey;
  dms = text:
    hotkey {
      color = magenta_dim;
      name = "󰮤  DankMaterialShell";
      inherit text;
    };
  foot = hotkey {
    color = yellow_dim;
    name = "  Foot";
    text = "Terminal Emulator";
  };
  librewolf = hotkey {
    color = blue2;
    name = "  Librewolf";
    text = "Web Browser";
  };
  euphonica = hotkey {
    color = cyan_bright;
    name = "󰦚  Euphonica";
    text = "GTK4 MPD frontend";
  };
  vesktop = hotkey {
    color = magenta_bright;
    name = "  Vesktop";
    text = "Discrod Client";
  };
  nix-search-tv = hotkey {
    color = blue1;
    name = "󱄅  Nix-search-tv";
    text = "Nix Fuzzey Search";
  };
  yazi = hotkey {
    color = yellow_dim;
    name = "󰇥  Yazi";
    text = "Terminal File Manager";
  };
  fcitx = hotkey {
    color = white3;
    name = "󰗊  Fcitx";
    text = "Switch Hazkey";
  };
  neovim = hotkey {
    color = green_bright;
    name = "  Neovim";
    text = "Codig Editor";
  };
  wlr = hotkey {
    color = orange_bright;
    name = "  Wlr-which-key";
    text = "Tools";
  };
in {
  flake.modules.homeManager.default = {config, ...}: let
    proDir = "${config.home.homeDirectory}/Projects";
  in {
    xdg.configFile."niri/binds.kdl".text =
      # kdl
      ''
        binds {
            // DMS
            Mod+Space hotkey-overlay-title="${dms "Launcher"}" { spawn "dms" "ipc" "call" "spotlight" "toggle"; }
            Mod+Y hotkey-overlay-title="${dms "Clipboard"}" { spawn "dms" "ipc" "call" "clipboard" "toggle"; }
            Mod+X hotkey-overlay-title="${dms "Powermenu"}" { spawn "dms" "ipc" "call" "powermenu" "toggle"; }
            Mod+W hotkey-overlay-title="${dms "Wallpaper"}" { spawn "dms" "ipc" "call" "dankdash" "wallpaper"; }
            Mod+N hotkey-overlay-title="${dms "Notifications"}" { spawn "dms" "ipc" "call" "notifications" "toggle"; }
            Mod+Alt+N hotkey-overlay-title="${dms "Notepad"}" { spawn "dms" "ipc" "call" "notepad" "toggle"; }
            Mod+I hotkey-overlay-title="${dms "Idle-inhibitor"}" { spawn "dms" "ipc" "call" "inhibit" "toggle"; }
            Mod+Comma hotkey-overlay-title="${dms "Settings"}" { spawn "dms" "ipc" "call" "settings" "focusOrToggle"; }
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
            Mod+Return hotkey-overlay-title="${foot}" { spawn "footclient"; }
            Mod+B hotkey-overlay-title="${librewolf}" { spawn "librewolf"; }
            Mod+E hotkey-overlay-title="${euphonica}" { spawn "euphonica"; }
            Mod+V hotkey-overlay-title="${vesktop}" { spawn "vesktop"; }
            Mod+Shift+Return hotkey-overlay-title="${neovim}" { spawn "footclient" "-D" "${proDir}" "-a" "nvim" "nvim"; }
            Mod+Shift+N hotkey-overlay-title="${nix-search-tv}" { spawn "footclient" "-a" "nix-search-tv" "ns"; }
            Mod+Shift+Y hotkey-overlay-title="${yazi}" { spawn "footclient" "-a" "yazi" "yazi"; }
            Mod+Slash hotkey-overlay-title="${wlr}" { spawn "wlr-which-key" "niri"; }
            Ctrl+Space hotkey-overlay-title="${fcitx}" { spawn "fcitx5-remote" "-t" ; }

            // Window
            Mod+Backspace repeat=false { close-window; }
            Mod+F       { maximize-column; }
            Mod+Shift+F { fullscreen-window; }
            Mod+Alt+F   { toggle-windowed-fullscreen; }
            Mod+T       { toggle-window-floating; }
            Mod+Shift+T { switch-focus-between-floating-and-tiling; }
            Mod+Alt+T   { toggle-column-tabbed-display; }

            // Focus
            Mod+H    { focus-column-or-monitor-left; }
            Mod+J    { focus-window-or-workspace-down; }
            Mod+K    { focus-window-or-workspace-up; }
            Mod+L    { focus-column-or-monitor-right; }
            Mod+Down { focus-workspace-down; }
            Mod+Up   { focus-workspace-up; }

            // Move
            Mod+Shift+H { move-column-left-or-to-monitor-left; }
            Mod+Shift+J { move-window-down-or-to-workspace-down; }
            Mod+Shift+K { move-window-up-or-to-workspace-up; }
            Mod+Shift+L { move-column-right-or-to-monitor-right; }

            // Column
            Mod+Home         { focus-column-first; }
            Mod+End          { focus-column-last; }
            Mod+Shift+Home   { move-column-to-first; }
            Mod+Shift+End    { move-column-to-last; }
            Mod+C            { center-column; }
            Mod+Alt+C        { center-visible-columns; }
            Mod+BracketLeft  { consume-or-expel-window-left; }
            Mod+BracketRight { consume-or-expel-window-right; }
            Mod+Period       { expel-window-from-column; }

            // Sizing & Layout
            Mod+R       { switch-preset-column-width; }
            Mod+Shift+R { switch-preset-window-height; }

            // Manual Sizing
            Mod+Minus { set-column-width "-10%"; }
            Mod+Equal { set-column-width "+10%"; }
            Mod+Shift+Minus { set-window-height "-10%"; }
            Mod+Shift+Equal { set-window-height "+10%"; }

            // Numbered Workspaces
            Mod+1 { focus-workspace 1; }
            Mod+2 { focus-workspace 2; }
            Mod+3 { focus-workspace 3; }
            Mod+4 { focus-workspace 4; }
            Mod+5 { focus-workspace 5; }
            Mod+6 { focus-workspace 6; }
            Mod+7 { focus-workspace 7; }
            Mod+8 { focus-workspace 8; }
            Mod+9 { focus-workspace 9; }

            Mod+Shift+1 { move-column-to-workspace 1; }
            Mod+Shift+2 { move-column-to-workspace 2; }
            Mod+Shift+3 { move-column-to-workspace 3; }
            Mod+Shift+4 { move-column-to-workspace 4; }
            Mod+Shift+5 { move-column-to-workspace 5; }
            Mod+Shift+6 { move-column-to-workspace 6; }
            Mod+Shift+7 { move-column-to-workspace 7; }
            Mod+Shift+8 { move-column-to-workspace 8; }
            Mod+Shift+9 { move-column-to-workspace 9; }

            // Mouse Wheel
            Mod+WheelScrollDown  cooldown-ms=150 { focus-workspace-down; }
            Mod+WheelScrollUp    cooldown-ms=150 { focus-workspace-up; }
            Mod+WheelScrollRight cooldown-ms=150 { focus-column-right; }
            Mod+WheelScrollLeft  cooldown-ms=150 { focus-column-left; }

            Mod+Shift+WheelScrollDown   { move-column-to-workspace-down; }
            Mod+Shift+WheelScrollUp     { move-column-to-workspace-up; }
            Mod+Shift+WheelScrollRight  { consume-or-expel-window-right; }
            Mod+Shift+WheelScrollLeft   { consume-or-expel-window-left; }

            // Touchpad
            Mod+TouchpadScrollDown        { focus-workspace-down; }
            Mod+TouchpadScrollUp          { focus-workspace-up; }
            Mod+TouchpadScrollRight       { focus-column-right; }
            Mod+TouchpadScrollLeft        { focus-column-left; }
            Mod+Shift+TouchpadScrollDown  { move-column-to-workspace-down; }
            Mod+Shift+TouchpadScrollUp    { move-column-to-workspace-up; }
            Mod+Shift+TouchpadScrollRight { move-column-right; }
            Mod+Shift+TouchpadScrollLeft  { move-column-left; }

            // Screenshot
            Mod+Backslash       { screenshot show-pointer=false; }
            Mod+Shift+Backslash { screenshot-screen show-pointer=false; }
            Mod+Alt+Backslash   { screenshot-window show-pointer=false; }

            // System
            Mod+Shift+Slash  { show-hotkey-overlay; }
            Mod+O            { toggle-overview; }
            Mod+Shift+Escape { quit skip-confirmation=false; }
            Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }
            Mod+Shift+P      { power-off-monitors; }
        }
      '';
  };
}
