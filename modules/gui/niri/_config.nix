{
  config,
  lib,
  pkgs,
  dotfile,
  ...
}: let
  inherit (lib) getExe;
  inherit (config.lib.custom.hardware.monitors) mainMonitor mainMonitorName;
in {
  hotkey-overlay = {
    skip-at-startup = [];
    hide-not-bound = [];
  };

  overview = {
    zoom = 0.500000;
    backdrop-color = "#414559";
    workspace-shadow = {color = "#232634" + "90";};
  };

  output = let
    mainWidth = mainMonitor.mode.width;
    mainHeight = mainMonitor.mode.height;
    mainRefresh = mainMonitor.mode.refresh;
    mainScale = mainMonitor.scale;
    mainRotate =
      if mainMonitor.rotation == 0
      then "normal"
      else toString mainMonitor.rotation;
    mainPositionX = mainMonitor.position.x;
    mainPositionY = mainMonitor.position.y;
    mainMode = "${toString mainWidth}x${toString mainHeight}@${toString mainRefresh}";
  in [
    {
      _args = [mainMonitorName];
      scale = mainScale;
      transform = mainRotate;
      position._props = {
        x = mainPositionX;
        y = mainPositionY;
      };
      mode = mainMode;
    }
  ];

  input = {
    keyboard = {
      xkb = {layout = "us";};
      repeat-delay = 600;
      repeat-rate = 25;
      track-layout = "global";
    };
    focus-follows-mouse = [];
    touchpad = {
      tap = [];
      natural-scroll = [];
    };
    tablet = {map-to-output = "DSI-1";};
    touch = {map-to-output = "DSI-1";};
  };

  cursor = {
    xcursor-theme = config.custom.gtk.cursor.name;
    xcursor-size = config.custom.gtk.cursor.size;
    hide-when-typing = [];
    hide-after-inactive-ms = 1000;
  };

  gestures = {
    dnd-edge-view-scroll = {
      trigger-width = 60;
      delay-ms = 100;
      max-speed = 1500;
    };
  };

  layout = {
    gaps = 14;
    center-focused-column = "never";
    always-center-single-column = [];
    empty-workspace-above-first = [];
    default-column-display = "tabbed";
    background-color = "transparent";

    preset-column-widths._children = [
      {proportion = 0.33333;}
      {proportion = 0.5;}
      {proportion = 0.66667;}
    ];

    default-column-width._children = [
      {proportion = 0.5;}
    ];

    preset-window-heights._children = [
      {proportion = 0.33333;}
      {proportion = 0.5;}
      {proportion = 0.66667;}
    ];

    focus-ring = {
      width = 3;
      active-gradient = {
        _props = {
          from = "#81C8BE";
          to = "#F4B8E4";
          angle = 45;
          "in" = "oklch longer hue";
        };
      };
      inactive-color = "#51576D";
    };

    border = {off = [];};

    shadow = {
      on = [];
      offset._props = {
        x = 0;
        y = 0;
      };
      softness = 20;
      spread = 10;
      draw-behind-window = false;
      color = "#232634" + "90";
    };

    tab-indicator = {
      hide-when-single-tab = true;
      place-within-column = true;
      gap = -15;
      width = 8;
      length = {
        _props.total-proportion = 0.800000;
      };
      position = "right";
      gaps-between-tabs = 0.000000;
      corner-radius = 0.000000;
      active-color = "#A6D189" + "90";
      inactive-color = "#414559" + "90";
    };

    insert-hint = {
      gradient = {
        _props = {
          angle = 45;
          from = "#A6D189";
          relative-to = "window";
          to = "#81C8BE";
        };
      };
    };

    struts = {
      left = 2;
      right = 2;
      top = 2;
      bottom = 2;
    };
  };

  window-rule = [
    # all windows
    {
      draw-border-with-background = false;
      geometry-corner-radius = [10.000000 10.000000 10.000000 10.000000];
      clip-to-geometry = true;
      background-effect = {
        blur = true;
        xray = true;
      };
    }
    # floating and focused
    {
      match = {
        _props = {
          is-floating = true;
          is-focused = true;
        };
      };
      focus-ring = {width = 2;};
      opacity = 0.880000;
      background-effect = {
        xray = false;
      };
    }
    # floating but not focused
    {
      match = {
        _props = {
          is-floating = true;
          is-focused = false;
        };
      };
      opacity = 0.650000;
      background-effect = {
        xray = false;
      };
    }
    # not floating but focused
    {
      match = {
        _props = {
          is-floating = false;
          is-focused = true;
        };
      };
      focus-ring = {width = 4;};
      opacity = 0.850000;
    }
    # not floating nor focused
    {
      match = {
        _props = {
          is-floating = false;
          is-focused = false;
        };
      };
      opacity = 0.500000;
    }
    # window-cast-target
    {
      match = {
        _props.is-window-cast-target = true;
      };
      focus-ring = {
        active-gradient = {
          _props = {
            from = "#EF9F76";
            to = "#E78284";
            angle = 45;
            "in" = "oklch longer hue";
          };
        };
        inactive-color = "#303446";
      };
      shadow = {
        on = [];
        offset._props = {
          x = 0;
          y = 0;
        };
        softness = 20;
        spread = 10;
        draw-behind-window = false;
        color = "#ECEFF490";
      };
      tab-indicator = {
        active-color = "#EA999C";
        inactive-color = "#51576D";
      };
    }
    # windows wanted to be floating
    {
      match = [
        {_props.app-id._raw = ''r#"^.blueman-manager-wrapped$"#'';}
        {_props.app-id._raw = ''r#"^com.github.wwmm.easyeffects$"#'';}
        # helium extension's windows
        {_props.app-id._raw = ''r#"^chrome-"#'';}
        {_props.app-id._raw = ''r#"^com.saivert.pwvucontrol$"#'';}
        {_props.app-id._raw = ''r#"^org.kde.kdeconnect-indicator$"#'';}
        {_props.app-id._raw = ''r#"^solaar$"#'';}
      ];
      open-floating = true;
    }
    # windows wanted to be floating and not transparent
    {
      match = [
        {_props.title._raw = ''r#"^Picture-in-Picture$"#'';}
        {_props.title._raw = ''r#"^ピクチャーインピクチャー$"#'';}
        {_props.title._raw = ''r#"^ピクチャー イン ピクチャー$"#'';}
        {_props.app-id._raw = ''r#"^mpv$"#'';}
        {_props.app-id._raw = ''r#"^vlc$"#'';}
        {_props.app-id._raw = ''r#"^com.gabm.satty$"#'';}
        {_props.app-id._raw = ''r#"^Pqiv$"#'';}
      ];
      open-floating = true;
      opacity = 1.000000;
    }
    # windows wanted to be floating and not shown on screen-capture
    {
      match = [
        {_props.app-id._raw = ''r#"^org.gnome.Nautilus$"#'';}
        {_props.app-id._raw = ''r#"^xdg-desktop-portal-gtk$"#'';}
        {_props.title._raw = ''r#"^yazi$"#'';}
      ];
      default-column-width._children = [
        {proportion = 0.500000;}
      ];
      default-window-height._children = [
        {proportion = 0.500000;}
      ];
      open-floating = true;
      block-out-from = "screen-capture";

      popups = {
        geometry-corner-radius = 15;
        opacity = 0.800000;
        background-effect = {
          blur = true;
          xray = false;
        };
      };
    }
    # windows wanted not to be shown on screen-capture
    {
      match = [
        {_props.app-id._raw = ''r#"^org.gnome.seahorse.Application$"#'';}
        {_props.app-id._raw = ''r#"^Proton Mail$"#'';}
        {_props.app-id._raw = ''r#"^Proton Pass$"#'';}
        {_props.app-id._raw = ''r#"^.protonvpn-app-wrapped$"#'';}
      ];
      block-out-from = "screen-capture";
    }
  ];

  layer-rule = [
    # wlr-which-key
    {
      match = [
        {_props.namespace._raw = ''r#"^wlr_which_key$"#'';}
      ];
      opacity = 0.880000;
      background-effect = {
        blur = true;
        xray = false;
      };
    }
  ];

  spawn-at-startup = [
    ["nm-applet"]
    ["blueman-applet"]
    ["solaar" "-w" "hide" "-b" "symbolic"]
  ];

  binds = let
    hotkey = color: name: text: ''<span foreground='${color}'>[${name}]</span> ${text}'';

    mkMenu = menu: let
      config = import ./wlr-which-key/_config.nix {inherit pkgs menu;};
    in
      pkgs.writeShellScriptBin "mkMenu" ''
        exec ${getExe pkgs.wlr-which-key} ${config}
      '';
    niriKey = mkMenu (import ./wlr-which-key/_niriMenu.nix);
    dmsKey = mkMenu (import ./wlr-which-key/_dmsMenu.nix);
  in {
    # dms
    "Mod+Space" = {
      _props.hotkey-overlay-title = "${hotkey "#CA9EE6" "󰮤  DankMaterialShell" "Launcher"}";
      spawn = ["dms" "ipc" "spotlight" "toggle"];
    };
    "Mod+Y" = {
      _props.hotkey-overlay-title = "${hotkey "#CA9EE6" "󰮤  DankMaterialShell" "Clipboard"}";
      spawn = ["dms" "ipc" "clipboard" "toggle"];
    };
    "Mod+X" = {
      _props.hotkey-overlay-title = "${hotkey "#CA9EE6" "󰮤  DankMaterialShell" "Powermenu"}";
      spawn = ["dms" "ipc" "powermenu" "toggle"];
    };
    "Mod+N" = {
      _props.hotkey-overlay-title = "${hotkey "#CA9EE6" "󰮤  DankMaterialShell" "Notepad"}";
      spawn = ["dms" "ipc" "notepad" "toggle"];
    };
    "Mod+D" = {
      _props.hotkey-overlay-title = "${hotkey "#CA9EE6" "󰮤  DankMaterialShell" "Command"}";
      spawn = ["${getExe dmsKey}"];
    };
    "Mod+Comma" = {
      _props.hotkey-overlay-title = "${hotkey "#CA9EE6" "󰮤  DankMaterialShell" "Settings"}";
      spawn = ["dms" "ipc" "settings" "focusOrToggle"];
    };
    "Mod+Ctrl+L" = {
      _props = {
        allow-when-locked = true;
        hotkey-overlay-title = "${hotkey "#CA9EE6" "󰮤  DankMaterialShell" "screen-lock"}";
      };
      spawn = ["dms" "ipc" "lock" "lock"];
    };

    # media-key
    "XF86AudioLowerVolume" = {
      _props.allow-when-locked = true;
      spawn = ["dms" "ipc" "audio" "decrement" "3"];
    };
    "XF86AudioMicMute" = {
      _props.allow-when-locked = true;
      spawn = ["dms" "ipc" "audio" "micmute"];
    };
    "XF86AudioMute" = {
      _props.allow-when-locked = true;
      spawn = ["dms" "ipc" "audio" "mute"];
    };
    "XF86AudioNext" = {
      _props.allow-when-locked = true;
      spawn = ["dms" "ipc" "mpris" "next"];
    };
    "XF86AudioPlay" = {
      _props.allow-when-locked = true;
      spawn = ["dms" "ipc" "mpris" "playPause"];
    };
    "XF86AudioPrev" = {
      _props.allow-when-locked = true;
      spawn = ["dms" "ipc" "mpris" "previous"];
    };
    "XF86AudioRaiseVolume" = {
      _props.allow-when-locked = true;
      spawn = ["dms" "ipc" "audio" "increment" "3"];
    };
    "XF86MonBrightnessDown" = {
      _props.allow-when-locked = true;
      spawn = ["dms" "ipc" "brightness" "decrement" "5" ""];
    };
    "XF86MonBrightnessUp" = {
      _props.allow-when-locked = true;
      spawn = ["dms" "ipc" "brightness" "increment" "5" ""];
    };

    # execute
    "Mod+Return" = {
      _props.hotkey-overlay-title = "${hotkey "#F2D5CF" "  Ghostty" "Terminal Emulator"}";
      spawn = ["ghostty"];
    };
    "Mod+Shift+Return" = {
      _props.hotkey-overlay-title = "${hotkey "#BABBF1" "  Helix" "Code Editor"}";
      spawn = ["ghostty" "--working-directory=${dotfile}" "-e" "hx"];
    };
    "Mod+B" = {
      _props.hotkey-overlay-title = "${hotkey "#8CAAEE" "󰖟  Helium" "Web Browser"}";
      spawn-sh = ["helium &"];
    };
    "Mod+Shift+D" = {
      _props.hotkey-overlay-title = "${hotkey "#EA999C" "󰗢  niri" "Command"}";
      spawn = ["${getExe niriKey}"];
    };
    "Mod+Shift+N" = {
      _props.hotkey-overlay-title = "${hotkey "#8CAAEE" "󱄅  Nix Search" "Nix Package"}";
      spawn = ["ghostty" "--title=ntv" "-e" "ntv"];
    };
    "Mod+Shift+Y" = {
      _props.hotkey-overlay-title = "${hotkey "#E5C890" "󰇥  Yazi" "File Manager"}";
      spawn = ["ghostty" "--title=yazi" "-e" "yazi"];
    };
    "Ctrl+Space" = {
      _props.hotkey-overlay-title = "${hotkey "#A6D189" "󰗊  Fcitx" "Switch input method"}";
      spawn = ["fcitx5-remote" "-t"];
    };

    # window
    "Mod+Backspace" = {
      _props.repeat = false;
      close-window = [];
    };
    "Mod+F" = {maximize-column = [];};
    "Mod+Shift+F" = {fullscreen-window = [];};
    "Mod+Alt+F" = {toggle-windowed-fullscreen = [];};
    "Mod+M" = {maximize-window-to-edges = [];};
    "Mod+T" = {toggle-window-floating = [];};
    "Mod+Shift+T" = {switch-focus-between-floating-and-tiling = [];};
    "Mod+Alt+T" = {toggle-column-tabbed-display = [];};

    # focus
    "Mod+H" = {focus-column-or-monitor-left = [];};
    "Mod+J" = {focus-window-or-workspace-down = [];};
    "Mod+K" = {focus-window-or-workspace-up = [];};
    "Mod+L" = {focus-column-or-monitor-right = [];};
    "Mod+Down" = {focus-monitor-down = [];};
    "Mod+Up" = {focus-monitor-up = [];};

    # move
    "Mod+Shift+H" = {move-column-left = [];};
    "Mod+Shift+J" = {move-window-down-or-to-workspace-down = [];};
    "Mod+Shift+K" = {move-window-up-or-to-workspace-up = [];};
    "Mod+Shift+L" = {move-column-right = [];};
    "Mod+Alt+H" = {move-column-to-monitor-left = [];};
    "Mod+Alt+J" = {move-column-to-monitor-down = [];};
    "Mod+Alt+K" = {move-column-to-monitor-up = [];};
    "Mod+Alt+L" = {move-column-to-monitor-right = [];};

    # column
    "Mod+Home" = {focus-column-first = [];};
    "Mod+End" = {focus-column-last = [];};
    "Mod+Shift+Home" = {move-column-to-first = [];};
    "Mod+Shift+End" = {move-column-to-last = [];};
    "Mod+C" = {center-column = [];};
    "Mod+Alt+C" = {center-visible-columns = [];};
    "Mod+BracketLeft" = {consume-or-expel-window-left = [];};
    "Mod+BracketRight" = {consume-or-expel-window-right = [];};
    "Mod+Period" = {expel-window-from-column = [];};

    # sizing and layout
    "Mod+R" = {switch-preset-column-width = [];};
    "Mod+Shift+R" = {switch-preset-window-height = [];};

    # manual sizing
    "Mod+Minus" = {set-column-width = "-10%";};
    "Mod+Equal" = {set-column-width = "+10%";};
    "Mod+Shift+Minus" = {set-window-height = "-10%";};
    "Mod+Shift+Equal" = {set-window-height = "+10%";};

    # numberred workspaces
    "Mod+1" = {focus-workspace = 1;};
    "Mod+2" = {focus-workspace = 2;};
    "Mod+3" = {focus-workspace = 3;};
    "Mod+4" = {focus-workspace = 4;};
    "Mod+5" = {focus-workspace = 5;};
    "Mod+6" = {focus-workspace = 6;};
    "Mod+7" = {focus-workspace = 7;};
    "Mod+8" = {focus-workspace = 8;};
    "Mod+9" = {focus-workspace = 9;};
    "Mod+Shift+1" = {move-column-to-workspace = 1;};
    "Mod+Shift+2" = {move-column-to-workspace = 2;};
    "Mod+Shift+3" = {move-column-to-workspace = 3;};
    "Mod+Shift+4" = {move-column-to-workspace = 4;};
    "Mod+Shift+5" = {move-column-to-workspace = 5;};
    "Mod+Shift+6" = {move-column-to-workspace = 6;};
    "Mod+Shift+7" = {move-column-to-workspace = 7;};
    "Mod+Shift+8" = {move-column-to-workspace = 8;};
    "Mod+Shift+9" = {move-column-to-workspace = 9;};

    # mouse wheel
    "Mod+WheelScrollDown" = {
      _props.cooldown-ms = 150;
      focus-workspace-down = [];
    };
    "Mod+WheelScrollUp" = {
      _props.cooldown-ms = 150;
      focus-workspace-up = [];
    };
    "Mod+WheelScrollRight" = {
      _props.cooldown-ms = 150;
      focus-column-right = [];
    };
    "Mod+WheelScrollLeft" = {
      _props.cooldown-ms = 150;
      focus-column-left = [];
    };
    "Mod+Shift+WheelScrollDown" = {move-column-to-workspace-down = [];};
    "Mod+Shift+WheelScrollUp" = {move-column-to-workspace-up = [];};
    "Mod+Shift+WheelScrollRight" = {consume-or-expel-window-right = [];};
    "Mod+Shift+WheelScrollLeft" = {consume-or-expel-window-left = [];};

    # touchpad
    "Mod+TouchpadScrollDown" = {focus-workspace-down = [];};
    "Mod+TouchpadScrollUp" = {focus-workspace-up = [];};
    "Mod+TouchpadScrollRight" = {focus-column-right = [];};
    "Mod+TouchpadScrollLeft" = {focus-column-left = [];};
    "Mod+Shift+TouchpadScrollDown" = {move-column-to-workspace-down = [];};
    "Mod+Shift+TouchpadScrollUp" = {move-column-to-workspace-up = [];};
    "Mod+Shift+TouchpadScrollRight" = {move-column-right = [];};
    "Mod+Shift+TouchpadScrollLeft" = {move-column-left = [];};

    # screenshot
    "Mod+Print" = {
      screenshot = {_props.show-pointer = false;};
    };
    "Mod+Shift+Print" = {
      screenshot-screen = {_props.show-pointer = false;};
    };
    "Mod+Alt+Print" = {
      screenshot-window = [];
    };

    # system
    "Mod+Shift+Slash" = {show-hotkey-overlay = [];};
    "Mod+O" = {toggle-overview = [];};
    "Mod+Shift+O" = {toggle-window-rule-opacity = [];};
    "Mod+Shift+Escape" = {
      quit = {_props.skip-confirmation = false;};
    };
    "Mod+Escape" = {
      _props.allow-inhibiting = false;
      toggle-keyboard-shortcuts-inhibit = [];
    };
    "Mod+Shift+P" = {power-off-monitors = [];};
  };

  recent-windows = {
    debounce-ms = 750;
    open-delay-ms = 150;
    highlight = {
      active-color = "#8CAAEE" + "ff";
      urgent-color = "#EA999C" + "ff";
      padding = 30;
      corner-radius = 10;
    };
    previews = {
      max-height = 480;
      max-scale = 0.5;
    };
    binds = {
      "Mod+Tab" = {next-window = [];};
      "Mod+Shift+Tab" = {previous-window = [];};
      "Mod+grave" = {
        next-window = {
          _props.filter = "app-id";
        };
      };
      "Mod+Shift+grave" = {
        previous-window = {
          _props.filter = "app-id";
        };
      };
    };
  };

  animations = {
    workspace-switch = {
      duration-ms = 300;
      curve = "ease-out-cubic";
    };

    window-open = {
      duration-ms = 500;
      curve = "linear";
      custom-shader =
        # glsl
        "
        vec4 open_color(vec3 coords_geo, vec3 size_geo) {
            vec3 coords_tex = niri_geo_to_tex * coords_geo;
            vec4 color = texture2D(niri_tex, coords_tex.st);
            float cellSize = 35.0;

            float p = niri_clamped_progress * (1.0 + cellSize * 0.015);
            vec2 coords = (coords_geo.xy - vec2(0.5, 0.5)) * size_geo.xy / size_geo.x;
            coords*= cellSize;
            coords.x += ceil(coords.y) * .5;
            vec2 cell = floor(-coords);
            coords = fract(coords);

            vec2 center = vec2(0.5);
            float offset = cell.y ;
            float d = distance(coords, center);
            float r = p + offset / cellSize;
            if (r < 0.25) {
             r = 0.0;
            }
            d = smoothstep(r-0.01, r+0.01, d);
            vec4 col = mix(color, vec4(0), d);
            return col;
          }
        ";
    };
    window-close = {
      duration-ms = 500;
      curve = "linear";
      custom-shader =
        # glsl
        "
        vec4 close_color(vec3 coords_geo, vec3 size_geo) {
            vec3 coords_tex = niri_geo_to_tex * coords_geo;
            vec4 color = texture2D(niri_tex, coords_tex.st);
            float cellSize = 35.0;

            float p = niri_clamped_progress * (1.0 + cellSize * 0.015);
            vec2 coords = (coords_geo.xy - vec2(0.0, 0.5)) * size_geo.xy / size_geo.x;
            coords*= cellSize;
            coords.x += ceil(coords.y) * .5;
            vec2 cell = floor(-coords);
            coords = fract(coords);

            vec2 center = vec2(0.5);
            float offset = cell.y ;
            float d = distance(coords, center);
            float r = 1.0 - p + offset / cellSize;
            if (r < 0.25) {
             r = 0.0;
            }
            d = smoothstep(r-0.01, r+0.01, d);
            vec4 col = mix(color, vec4(0), d);
            return col;
        }
        ";
    };
  };

  prefer-no-csd = [];

  screenshot-path = "${config.hj.directory}/Pictures/Screenshots/screenshot_%Y-%m-%d_%H-%M-%S.png";

  xwayland-satellite = let
    # xwayland
    xwayland =
      if config.custom.programs.niri.xwayland
      then {
        path = getExe pkgs.xwayland-satellite-unstable;
      }
      else {
        off = [];
      };
  in
    xwayland;

  clipboard = {disable-primary = [];};

  environment = {
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    GDK_BACKEND = "wayland";
    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_QPA_PLATFORMTHEME_QT6 = "qt6ct";
    QT_STYLE_OVERRIDE = "kvantum";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
  };

  blur = {
    passes = 3;
    offset = 3.0;
    noise = 0.02;
    saturation = 1.5;
  };

  include = [
    ["dms/alttab.kdl"]
    ["dms/binds.kdl"]
    ["dms/colors.kdl"]
    ["dms/cursor.kdl"]
    ["dms/layout.kdl"]
    ["dms/outputs.kdl"]
    ["dms/windowrules.kdl"]
    ["dms/wpblur.kdl"]
  ];
}
