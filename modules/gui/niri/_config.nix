{
  config,
  lib,
  pkgs,
  dms ? "",
  ...
}: let
  inherit (lib) getExe;
  # output
  inherit (config.lib.monitors) mainMonitor mainMonitorName;
  mainWidth = toString mainMonitor.mode.width;
  mainHeight = toString mainMonitor.mode.height;
  mainRefresh = toString mainMonitor.mode.refresh;
  mainScale = toString mainMonitor.scale;
  mainRotate =
    if mainMonitor.rotation == 0
    then "normal"
    else toString mainMonitor.rotation;
  mainPositionX = toString mainMonitor.position.x;
  mainPositionY = toString mainMonitor.position.y;
  mainMode = "${mainWidth}x${mainHeight}@${mainRefresh}";
  # cursor
  cursorName = config.home.pointerCursor.name;
  cursorSize = toString config.home.pointerCursor.size;
  # xwayland
  xwayland =
    if config.custom.niri.xwayland
    then ''path "${getExe pkgs.xwayland-satellite}"''
    else "off";
  # screenshot
  inherit (config.xdg.userDirs) pictures;
  inherit (config.custom.niri.screenshot) host;
  # keybinds
  hotkey = color: name: text: ''<span foreground='${color}'>[${name}]</span> ${text}'';
  proDir = "${config.home.homeDirectory}/Projects";
in
  pkgs.writeText "niri-wrapped-config.kdl"
  # kdl
  ''
    output "${mainMonitorName}" {
        scale ${mainScale}
        transform "${mainRotate}"
        position x=${mainPositionX} y=${mainPositionY}
        mode "${mainMode}"
    }

    input {
        focus-follows-mouse
        keyboard {
            xkb {
                layout "us"
                model ""
                rules ""
                variant ""
            }
            repeat-delay 600
            repeat-rate 25
            track-layout "global"
        }
        touchpad {
            tap
            natural-scroll
        }
        tablet { map-to-output "DSI-1"; }
        touch { map-to-output "DSI-1"; }
    }

    prefer-no-csd

    screenshot-path "${pictures}/Screenshots/${host}/%Y-%m-%d_%H-%M-%S.png"

    environment {
        "ELECTRON_OZONE_PLATFORM_HINT" "auto"
        "GDK_BACKEND" "wayland"
        "QT_QPA_PLATFORM" "wayland"
        "QT_QPA_PLATFORMTHEME" "qt5ct"
        "QT_QPA_PLATFORMTHEME_QT6" "qt6ct"
        "QT_STYLE_OVERRIDE" "kvantum"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION" "1"
        "XDG_CURRENT_DESKTOP" "niri"
        "XDG_SESSION_TYPE" "wayland"
    }

    cursor {
        xcursor-theme "${cursorName}"
        xcursor-size ${cursorSize}
        hide-when-typing
        hide-after-inactive-ms 1000
    }

    overview {
        zoom 0.500000
        backdrop-color "#3B4252"
        workspace-shadow { color "#3B425290"; }
    }

    xwayland-satellite {
        ${xwayland}
    }

    clipboard {
        disable-primary
    }

    hotkey-overlay {
        skip-at-startup
        hide-not-bound
    }

    gestures {
        dnd-edge-view-scroll {
            trigger-width 60
            delay-ms 100
            max-speed 1500
        }
    }

    recent-windows {
        debounce-ms 750
        open-delay-ms 150
        highlight {
            active-color "#88C0D0ff"
            urgent-color "#D79784ff"
            padding 30
            corner-radius 0
        }
        previews {
            max-height 480
            max-scale 0.5
        }
        binds {
            Mod+Tab { next-window; }
            Mod+Shift+Tab { previous-window; }
            Mod+grave { next-window filter="app-id"; }
            Mod+Shift+grave { previous-window filter="app-id"; }
        }
    }

    // spawn
    spawn-at-startup "nm-applet"
    spawn-at-startup "blueman-applet"
    spawn-at-startup "solaar" "-w" "hide" "-b" "symbolic"

    // layout
    layout {
        gaps 14
        center-focused-column "never"
        always-center-single-column
        empty-workspace-above-first
        default-column-display "tabbed"
        background-color "transparent"

        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
        }

        default-column-width { proportion 0.5; }

        preset-window-heights {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
        }

        focus-ring {
            width 4
            active-gradient angle=180 from="#B1C89D" relative-to="window" to="#9FC6C5"
            inactive-color "#434C5E"
        }

        border { off; }

        shadow {
            on
            offset x=0 y=0
            softness 20
            spread 10
            draw-behind-window false
            color "#191D2490"
        }

        tab-indicator {
            hide-when-single-tab
            place-within-column
            gap -15
            width 8
            length total-proportion=0.800000
            position "bottom"
            gaps-between-tabs 0.000000
            corner-radius 0.000000
            active-color "#191D2490"
            inactive-color "#434C5E90"
        }

        insert-hint { gradient angle=45 from="#97B67C" relative-to="window" to="#B1C89D"; }

        struts {
            left 2
            right 2
            top 2
            bottom 2
        }
    }

    // window-rule
    window-rule {
        draw-border-with-background false
        geometry-corner-radius 10.000000 10.000000 10.000000 10.000000
        clip-to-geometry true
    }
    window-rule {
        match is-floating=true is-focused=true
        focus-ring { width 2; }
        opacity 0.980000
    }
    window-rule {
        match is-floating=true is-focused=false
        opacity 0.950000
    }
    window-rule {
        match is-floating=false is-focused=true
        focus-ring { width 4; }
        opacity 0.950000
    }
    window-rule {
        match is-floating=false is-focused=false
        opacity 0.900000
    }

    window-rule {
        match is-window-cast-target=true
        focus-ring {
            active-gradient angle=180 from="#D79784" relative-to="window" to="#C5727A"
            inactive-color "#434C5E"
        }
        shadow {
            on
            offset x=0 y=0
            softness 20
            spread 10
            draw-behind-window false
            color "#ECEFF490"
        }
        tab-indicator {
            active-color "#C5727A"
            inactive-color "#434C5E"
        }
    }

    window-rule {
        match app-id="^.blueman-manager-wrapped$"
        open-floating true
    }
    window-rule {
        match app-id="^chrome-"
        open-floating true
    }
    window-rule {
        match app-id="^com.gabm.satty$"
        default-column-width { proportion 0.800000; }
        default-window-height { proportion 0.800000; }
        open-floating true
        opacity 1.000000
    }
    window-rule {
        match app-id="^com.github.wwmm.easyeffects$"
        default-column-width { proportion 0.500000; }
        default-window-height { proportion 0.500000; }
        open-floating true
    }
    window-rule {
        match app-id="^com.saivert.pwvucontrol$"
        open-floating true
    }
    window-rule {
        match app-id="^dissent$"
        default-column-width { proportion 0.380000; }
        default-window-height { proportion 0.380000; }
        open-floating true
        opacity 1.000000
    }
    window-rule {
        match app-id="^mpv$"
        default-column-width { proportion 0.500000; }
        default-window-height { proportion 0.480000; }
        open-floating true
        opacity 1.000000
    }
    window-rule {
        match app-id="^org.gnome.Nautilus$"
        match app-id="^xdg-desktop-portal-gtk$"
        default-column-width { proportion 0.500000; }
        default-window-height { proportion 0.500000; }
        open-floating true
        block-out-from "screen-capture"
    }
    window-rule {
        match app-id="^org.kde.kdeconnect-indicator$"
        open-floating true
    }
    window-rule {
        match title="^Picture-in-Picture$"
        match title="^ピクチャーインピクチャー$"
        match title="^ピクチャー イン ピクチャー$"
        open-floating true
        opacity 1.000000
    }
    window-rule {
        match app-id="^solaar$"
        open-floating true
    }
    window-rule {
        match app-id="^swayimg$"
        default-column-width { proportion 0.500000; }
        default-window-height { proportion 0.500000; }
        open-floating true
        opacity 1.000000
    }
    window-rule {
        match app-id="^org.gnome.seahorse.Application$"
        block-out-from "screen-capture"
    }
    window-rule {
        match app-id="^Proton Mail$"
        match app-id="^Proton Pass$"
        match app-id="^.protonvpn-app-wrapped$"
        block-out-from "screen-capture"
    }
    window-rule {
        match app-id="^vlc$"
        open-floating true
        opacity 1.000000
    }
    window-rule {
        match app-id="^yazi$"
        default-column-width { proportion 0.500000; }
        default-window-height { proportion 0.500000; }
        open-floating true
        block-out-from "screen-capture"
    }

    // binds
    binds {
        // DMS
        Mod+Space hotkey-overlay-title="${hotkey "#BE9DB8" "󰮤  DankMaterialShell" "Launcher"}" { spawn "dms" "ipc" "spotlight" "toggle"; }
        Mod+Y hotkey-overlay-title="${hotkey "#BE9DB8" "󰮤  DankMaterialShell" "Clipboard"}"    { spawn "dms" "ipc" "clipboard" "toggle"; }
        Mod+X hotkey-overlay-title="${hotkey "#BE9DB8" "󰮤  DankMaterialShell" "Powermenu"}"    { spawn "dms" "ipc" "powermenu" "toggle"; }
        Mod+N hotkey-overlay-title="${hotkey "#BE9DB8" "󰮤  DankMaterialShell" "Notepad"}"      { spawn "dms" "ipc" "notepad" "toggle"; }
        Mod+Comma hotkey-overlay-title="${hotkey "#BE9DB8" "󰮤  DankMaterialShell" "Settings"}" { spawn "dms" "ipc" "settings" "focusOrToggle"; }
        Mod+Ctrl+L allow-when-locked=true hotkey-overlay-title="${hotkey "#BE9DB8" "󰮤  DankMaterialShell" "Screen-lock"}" { spawn "dms" "ipc" "lock" "lock"; }

        XF86AudioLowerVolume allow-when-locked=true  { spawn "dms" "ipc" "audio" "decrement" "3"; }
        XF86AudioMicMute allow-when-locked=true      { spawn "dms" "ipc" "audio" "micmute"; }
        XF86AudioMute allow-when-locked=true         { spawn "dms" "ipc" "audio" "mute"; }
        XF86AudioNext allow-when-locked=true         { spawn "dms" "ipc" "mpris" "next"; }
        XF86AudioPlay allow-when-locked=true         { spawn "dms" "ipc" "mpris" "playPause"; }
        XF86AudioPrev allow-when-locked=true         { spawn "dms" "ipc" "mpris" "previous"; }
        XF86AudioRaiseVolume allow-when-locked=true  { spawn "dms" "ipc" "audio" "increment" "3"; }
        XF86MonBrightnessDown allow-when-locked=true { spawn "dms" "ipc" "brightness" "decrement" "5" ""; }
        XF86MonBrightnessUp allow-when-locked=true   { spawn "dms" "ipc" "brightness" "increment" "5" ""; }

            // Execute
        Mod+Return hotkey-overlay-title="${hotkey "#CB775D" "  Kitty" "Terminal Emulator"}" { spawn "kitty"; }
        Mod+B hotkey-overlay-title="${hotkey "#88C0D0" "  Helium" "Web Browser"}"           { spawn-sh "helium &"; }
        Mod+E hotkey-overlay-title="${hotkey "#9FC6C5" "  Euphonica" "MPD Client"}"         { spawn "euphonica"; }
        Mod+D hotkey-overlay-title="${hotkey "#BE9DB8" "  Dissent" "Discord Client"}"       { spawn "dissent"; }
        Mod+W hotkey-overlay-title="${hotkey "#B1C89D" "  Wlr-which-key" "Command"}"        { spawn "wlr-which-key" "niri"; }
        Mod+Shift+Return hotkey-overlay-title="${hotkey "#97B67C" "  Neovim" "Editor"}"     { spawn "kitty" "-d" "${proDir}" "--app-id" "nvim" "nvim"; }
        Mod+Shift+N hotkey-overlay-title="${hotkey "#5E81AC" "󱄅  Nix Search" "Nix Package"}" { spawn "kitty" "--app-id" "nix-search-tv" "ns"; }
        Mod+Shift+Y hotkey-overlay-title="${hotkey "#EFD49F" "󰇥  Yazi" "File Manager"}"      { spawn "kitty" "--app-id" "yazi" "yazi"; }
        Ctrl+Space hotkey-overlay-title="${hotkey "#BF616A" "󰗊  Fcitx" "Input Method"}"      { spawn "fcitx5-remote" "-t"; }

        // Window
        Mod+Backspace repeat=false { close-window; }
        Mod+F       { maximize-column; }
        Mod+Shift+F { fullscreen-window; }
        Mod+Alt+F   { toggle-windowed-fullscreen; }
        Mod+M       { maximize-window-to-edges; }
        Mod+T       { toggle-window-floating; }
        Mod+Shift+T { switch-focus-between-floating-and-tiling; }
        Mod+Alt+T   { toggle-column-tabbed-display; }

        // Focus
        Mod+H    { focus-column-or-monitor-left; }
        Mod+J    { focus-window-or-workspace-down; }
        Mod+K    { focus-window-or-workspace-up; }
        Mod+L    { focus-column-or-monitor-right; }
        Mod+Down { focus-monitor-down; }
        Mod+Up   { focus-monitor-up; }

        // Move
        Mod+Shift+H { move-column-left; }
        Mod+Shift+J { move-window-down-or-to-workspace-down; }
        Mod+Shift+K { move-window-up-or-to-workspace-up; }
        Mod+Shift+L { move-column-right; }
        Mod+Alt+H   { move-column-to-monitor-left; }
        Mod+Alt+J   { move-column-to-monitor-down; }
        Mod+Alt+K   { move-column-to-monitor-up; }
        Mod+Alt+L   { move-column-to-monitor-right; }

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
        Mod+Alt+Backslash   { screenshot-window; }

        // System
        Mod+Shift+Slash  { show-hotkey-overlay; }
        Mod+O            { toggle-overview; }
        Mod+Shift+O      { toggle-window-rule-opacity; }
        Mod+Shift+Escape { quit skip-confirmation=false; }
        Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }
        Mod+Shift+P      { power-off-monitors; }
    }

    // animation
    animations {
        workspace-switch {
            spring damping-ratio=0.80 stiffness=523 epsilon=0.0001
        }
        window-open {
            duration-ms 1400
            curve "ease-out-expo"
            custom-shader r"
                float ease_curve(float x) {
                    return x < 0.5 ? 4.0*x*x*x : 1.0 - pow(-2.0*x + 2.0, 3.0)/2.0;
                }

                vec4 open_color(vec3 coords_geo, vec3 size_geo) {
                    float t = niri_clamped_progress;
                    float prog = ease_curve(t);

                    // bottom-right corner
                    vec2 start = vec2(1.0, 1.0);

                    // compute distance along diagonal from corner
                    vec2 p = coords_geo.xy;
                    vec2 dir = vec2(-1.0, -1.0); // vector toward top-left
                    float dist = dot(p - start, dir);

                    // normalize distance to max diagonal (from corner to opposite)
                    float max_diag = 2.0;
                    float norm_dist = dist / max_diag;

                    // pixels not yet reached by sweep are invisible
                    if (norm_dist > prog) {
                        return vec4(0.0);
                    }

                    // sample normally
                    vec3 coords_tex = niri_geo_to_tex * coords_geo;
                    vec4 col = texture2D(niri_tex, coords_tex.xy);

                    return col;
                }
            "
        }

        window-close {
            duration-ms 1400
            curve "ease-out-expo"
            custom-shader r"
                // ease-in-out cubic curve helper
                float ease_curve(float x) {
                    return x < 0.5 ? 4.0*x*x*x : 1.0 - pow(-2.0*x + 2.0, 3.0)/2.0;
                }

                vec4 close_color(vec3 coords_geo, vec3 size_geo) {
                    float t = niri_clamped_progress;
                    float prog = ease_curve(t);

                    // choose corner: 0=top-left,1=top-right,2=bottom-left,3=bottom-right
                    int corner = 0;
                    vec2 start;
                    if (corner == 0) start = vec2(0.0,0.0);
                    else if (corner == 1) start = vec2(1.0,0.0);
                    else if (corner == 2) start = vec2(0.0,1.0);
                    else start = vec2(1.0,1.0);

                    // compute distance along diagonal from corner
                    vec2 p = coords_geo.xy;
                    float dist = dot(p - start, vec2(1.0,1.0));

                    // normalize distance to max diagonal
                    float max_diag = 2.0; // max of vec2(1,1)
                    float norm_dist = dist / max_diag;

                    // If pixel is behind the sweeping line, make it invisible
                    if (norm_dist <= prog) {
                        return vec4(0.0);
                    }

                    // sample normally
                    vec3 coords_tex = niri_geo_to_tex * coords_geo;
                    vec4 col = texture2D(niri_tex, coords_tex.xy);

                    return col;
                }
            "
        }

        horizontal-view-movement {
            spring damping-ratio=0.85 stiffness=423 epsilon=0.0001
        }
        window-movement {
            spring damping-ratio=0.75 stiffness=323 epsilon=0.0001
        }
        window-resize {
            custom-shader r"
                vec4 resize_color(vec3 coords_curr_geo, vec3 size_curr_geo) {
                    vec3 coords_tex_next = niri_geo_to_tex_next * coords_curr_geo;
                    vec4 color = texture2D(niri_tex_next, coords_tex_next.st);
                    return color;
                }
            "
        }
        config-notification-open-close {
            spring damping-ratio=0.65 stiffness=923 epsilon=0.001
        }
        screenshot-ui-open {
            duration-ms 200
            curve "ease-out-quad"
        }
        overview-open-close {
            spring damping-ratio=0.85 stiffness=800 epsilon=0.0001
        }
    }

    ${dms}
  ''
