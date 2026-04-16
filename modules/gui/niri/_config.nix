{
  config,
  lib,
  pkgs,
  dotfile,
  ...
}: let
  inherit (lib) getExe;
  inherit (config.networking) hostName;

  # output
  inherit (config.lib.custom.hardware.monitors) mainMonitor mainMonitorName;
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

  # cursor
  cursorName = config.custom.gtk.cursor.name;
  cursorSize = config.custom.gtk.cursor.size;

  # xwayland
  xwayland =
    if config.custom.programs.niri.xwayland
    then {
      path = getExe pkgs.xwayland-satellite;
    }
    else {
      off = [];
    };

  # screenshot
  pictures = "${config.hj.directory}/Pictures";

  # keybinds
  hotkey = color: name: text: ''<span foreground='${color}'>[${name}]</span> ${text}'';

  mkMenu = menu: let
    config = import ./wlr-which-key/_config.nix {inherit pkgs menu;};
  in
    pkgs.writeShellScriptBin "mkMenu" ''
      exec ${getExe pkgs.wlr-which-key} ${config}
    '';
  niriCmd = mkMenu (import ./wlr-which-key/_niriMenu.nix);
  dmsCmd = mkMenu (import ./wlr-which-key/_dmsMenu.nix);
in {
  prefer-no-csd = [];
  screenshot-path = "${pictures}/Screenshots/%Y-%m-%d_%H-%M-%S_${hostName}.png";
  xwayland-satellite = xwayland;
  clipboard = {disable-primary = [];};
  hotkey-overlay = {
    skip-at-startup = [];
    hide-not-bound = [];
  };
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
  spawn-at-startup = [
    ["nm-applet"]
    ["blueman-applet"]
    ["solaar" "-w" "hide" "-b" "symbolic"]
  ];

  output = [
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
    xcursor-theme = cursorName;
    xcursor-size = cursorSize;
    hide-when-typing = [];
    hide-after-inactive-ms = 1000;
  };

  overview = {
    zoom = 0.500000;
    backdrop-color = "#3B4252";
    workspace-shadow = {color = "#3B425290";};
  };

  gestures = {
    dnd-edge-view-scroll = {
      trigger-width = 60;
      delay-ms = 100;
      max-speed = 1500;
    };
  };

  recent-windows = {
    debounce-ms = 750;
    open-delay-ms = 150;
    highlight = {
      active-color = "#88C0D0ff";
      urgent-color = "#D79784ff";
      padding = 30;
      corner-radius = 0;
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
      width = 4;
      active-gradient = {
        _props = {
          angle = 180;
          from = "#B1C89D";
          relative-to = "window";
          to = "#9FC6C5";
        };
      };
      inactive-color = "#434C5E";
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
      color = "#191D2490";
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
      active-color = "#191D2490";
      inactive-color = "#434C5E90";
    };

    insert-hint = {
      gradient = {
        _props = {
          angle = 45;
          from = "#97B67C";
          relative-to = "window";
          to = "#B1C89D";
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
    {
      draw-border-with-background = false;
      geometry-corner-radius = [10.000000 10.000000 10.000000 10.000000];
      clip-to-geometry = true;
    }
    {
      match = {
        _props = {
          is-floating = true;
          is-focused = true;
        };
      };
      focus-ring = {width = 2;};
      opacity = 0.980000;
    }
    {
      match = {
        _props = {
          is-floating = true;
          is-focused = false;
        };
      };
      opacity = 0.950000;
    }
    {
      match = {
        _props = {
          is-floating = false;
          is-focused = true;
        };
      };
      focus-ring = {width = 4;};
      opacity = 0.950000;
    }
    {
      match = {
        _props = {
          is-floating = false;
          is-focused = false;
        };
      };
      opacity = 0.900000;
    }
    {
      match = {
        _props.is-window-cast-target = true;
      };
      focus-ring = {
        active-gradient = {
          _props = {
            angle = 180;
            from = "#D79784";
            relative-to = "window";
            to = "#C5727A";
          };
        };
        inactive-color = "#434C5E";
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
        active-color = "#C5727A";
        inactive-color = "#434C5E";
      };
    }
    {
      match = {
        _props.app-id._raw = ''r#"^.blueman-manager-wrapped$"#'';
      };
      open-floating = true;
    }
    {
      match = {
        _props.app-id._raw = ''r#"^chrome-"#'';
      };
      open-floating = true;
    }
    {
      match = {
        _props.app-id._raw = ''r#"^com.gabm.satty$"#'';
      };
      default-column-width._children = [
        {proportion = 0.800000;}
      ];
      default-window-height._children = [
        {proportion = 0.800000;}
      ];
      open-floating = true;
      opacity = 1.000000;
    }
    {
      match = {
        _props.app-id._raw = ''r#"^com.github.wwmm.easyeffects$"#'';
      };
      default-column-width._children = [
        {proportion = 0.500000;}
      ];
      default-window-height._children = [
        {proportion = 0.500000;}
      ];
      open-floating = true;
    }
    {
      match = {
        _props.app-id._raw = ''r#"^com.saivert.pwvucontrol$"#'';
      };
      open-floating = true;
    }
    {
      match = {
        _props.app-id._raw = ''r#"^mpv$"#'';
      };
      default-column-width._children = [
        {proportion = 0.500000;}
      ];
      default-window-height._children = [
        {proportion = 0.480000;}
      ];
      open-floating = true;
      opacity = 1.000000;
    }
    {
      match = {
        _props.app-id._raw = ''r#"^nix-search-tv$"#'';
      };
      default-column-width._children = [
        {proportion = 0.500000;}
      ];
      default-window-height._children = [
        {proportion = 0.750000;}
      ];
      open-floating = true;
    }
    {
      match = [
        {_props.app-id._raw = ''r#"^org.gnome.Nautilus$"#'';}
        {_props.app-id._raw = ''r#"^xdg-desktop-portal-gtk$"#'';}
      ];
      default-column-width._children = [
        {proportion = 0.500000;}
      ];
      default-window-height._children = [
        {proportion = 0.500000;}
      ];
      open-floating = true;
      block-out-from = "screen-capture";
    }
    {
      match = {
        _props.app-id._raw = ''r#"^org.kde.kdeconnect-indicator$"#'';
      };
      open-floating = true;
    }
    {
      match = [
        {_props.title._raw = ''r#"^Picture-in-Picture$"#'';}
        {_props.title._raw = ''r#"^ピクチャーインピクチャー$"#'';}
        {_props.title._raw = ''r#"^ピクチャー イン ピクチャー$"#'';}
      ];
      open-floating = true;
      opacity = 1.000000;
    }
    {
      match = {
        _props.app-id._raw = ''r#"^solaar$"#'';
      };
      open-floating = true;
    }
    {
      match = {
        _props.app-id._raw = ''r#"^Pqiv$"#'';
      };
      default-column-width._children = [
        {proportion = 0.400000;}
      ];
      default-window-height._children = [
        {proportion = 0.400000;}
      ];
      open-floating = true;
      opacity = 1.000000;
    }
    {
      match = {
        _props.app-id._raw = ''r#"^org.gnome.seahorse.Application$"#'';
      };
      block-out-from = "screen-capture";
    }
    {
      match = [
        {_props.app-id._raw = ''r#"^Proton Mail$"#'';}
        {_props.app-id._raw = ''r#"^Proton Pass$"#'';}
        {_props.app-id._raw = ''r#"^.protonvpn-app-wrapped$"#'';}
      ];
      block-out-from = "screen-capture";
    }
    {
      match = {
        _props.app-id._raw = ''r#"^vlc$"#'';
      };
      open-floating = true;
      opacity = 1.000000;
    }
    {
      match = {
        _props.app-id._raw = ''r#"^yazi$"#'';
      };
      default-column-width._children = [
        {proportion = 0.500000;}
      ];
      default-window-height._children = [
        {proportion = 0.500000;}
      ];
      open-floating = true;
      block-out-from = "screen-capture";
    }
  ];

  binds = {
    "Mod+Space" = {
      _props.hotkey-overlay-title = "${hotkey "#BE9DB8" "󰮤  DankMaterialShell" "Launcher"}";
      spawn = ["dms" "ipc" "spotlight" "toggle"];
    };
    "Mod+Y" = {
      _props.hotkey-overlay-title = "${hotkey "#BE9DB8" "󰮤  DankMaterialShell" "Clipboard"}";
      spawn = ["dms" "ipc" "clipboard" "toggle"];
    };
    "Mod+X" = {
      _props.hotkey-overlay-title = "${hotkey "#BE9DB8" "󰮤  DankMaterialShell" "Powermenu"}";
      spawn = ["dms" "ipc" "powermenu" "toggle"];
    };
    "Mod+N" = {
      _props.hotkey-overlay-title = "${hotkey "#BE9DB8" "󰮤  DankMaterialShell" "Notepad"}";
      spawn = ["dms" "ipc" "notepad" "toggle"];
    };
    "Mod+D" = {
      _props.hotkey-overlay-title = "${hotkey "#BE9DB8" "󰮤  DankMaterialShell" "Command"}";
      spawn = ["${getExe dmsCmd}"];
    };
    "Mod+Comma" = {
      _props.hotkey-overlay-title = "${hotkey "#BE9DB8" "󰮤  DankMaterialShell" "Settings"}";
      spawn = ["dms" "ipc" "settings" "focusOrToggle"];
    };
    "Mod+Ctrl+L" = {
      _props = {
        allow-when-locked = true;
        hotkey-overlay-title = "${hotkey "#BE9DB8" "󰮤  DankMaterialShell" "screen-lock"}";
      };
      spawn = ["dms" "ipc" "lock" "lock"];
    };
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

    "Mod+Return" = {
      _props.hotkey-overlay-title = "${hotkey "#CB775D" "  Kitty" "Terminal Emulator"}";
      spawn = ["kitty"];
    };
    "Mod+Shift+Return" = {
      _props.hotkey-overlay-title = "${hotkey "#BE9DB8" "  Helix" "Code Editor"}";
      spawn = ["kitty" "--directory" "${dotfile}" "--app-id" "helix" "hx" "."];
    };
    "Mod+B" = {
      _props.hotkey-overlay-title = "${hotkey "#88C0D0" "󰖟  Helium" "Web Browser"}";
      spawn-sh = ["helium &"];
    };
    "Mod+Shift+D" = {
      _props.hotkey-overlay-title = "${hotkey "#D79784" "󰗢  niri" "Command"}";
      spawn = ["${getExe niriCmd}"];
    };
    "Mod+Shift+N" = {
      _props.hotkey-overlay-title = "${hotkey "#5E81AC" "󱄅  Nix Search" "Nix Package"}";
      spawn = ["kitty" "--app-id" "nix-search-tv" "ntv"];
    };
    "Mod+Shift+Y" = {
      _props.hotkey-overlay-title = "${hotkey "#EFD49F" "󰇥  Yazi" "File Manager"}";
      spawn = ["kitty" "--app-id" "yazi" "yazi"];
    };
    "Ctrl+Space" = {
      _props.hotkey-overlay-title = "${hotkey "#BF616A" "󰗊  Fcitx" "Switch input method"}";
      spawn = ["fcitx5-remote" "-t"];
    };

    "Mod+Backspace" = {
      _props.repeat = false;
      close-window = [];
    };
    "Mod+F" = {
      maximize-column = [];
    };
    "Mod+Shift+F" = {
      fullscreen-window = [];
    };
    "Mod+Alt+F" = {
      toggle-windowed-fullscreen = [];
    };
    "Mod+M" = {
      maximize-window-to-edges = [];
    };
    "Mod+T" = {
      toggle-window-floating = [];
    };
    "Mod+Shift+T" = {
      switch-focus-between-floating-and-tiling = [];
    };
    "Mod+Alt+T" = {
      toggle-column-tabbed-display = [];
    };

    "Mod+H" = {
      focus-column-or-monitor-left = [];
    };
    "Mod+J" = {
      focus-window-or-workspace-down = [];
    };
    "Mod+K" = {
      focus-window-or-workspace-up = [];
    };
    "Mod+L" = {
      focus-column-or-monitor-right = [];
    };
    "Mod+Down" = {
      focus-monitor-down = [];
    };
    "Mod+Up" = {
      focus-monitor-up = [];
    };

    "Mod+Shift+H" = {
      move-column-left = [];
    };
    "Mod+Shift+J" = {
      move-window-down-or-to-workspace-down = [];
    };
    "Mod+Shift+K" = {
      move-window-up-or-to-workspace-up = [];
    };
    "Mod+Shift+L" = {
      move-column-right = [];
    };
    "Mod+Alt+H" = {
      move-column-to-monitor-left = [];
    };
    "Mod+Alt+J" = {
      move-column-to-monitor-down = [];
    };
    "Mod+Alt+K" = {
      move-column-to-monitor-up = [];
    };
    "Mod+Alt+L" = {
      move-column-to-monitor-right = [];
    };

    "Mod+Home" = {
      focus-column-first = [];
    };
    "Mod+End" = {
      focus-column-last = [];
    };
    "Mod+Shift+Home" = {
      move-column-to-first = [];
    };
    "Mod+Shift+End" = {
      move-column-to-last = [];
    };
    "Mod+C" = {
      center-column = [];
    };
    "Mod+Alt+C" = {
      center-visible-columns = [];
    };
    "Mod+BracketLeft" = {
      consume-or-expel-window-left = [];
    };
    "Mod+BracketRight" = {
      consume-or-expel-window-right = [];
    };
    "Mod+Period" = {
      expel-window-from-column = [];
    };

    "Mod+R" = {
      switch-preset-column-width = [];
    };
    "Mod+Shift+R" = {
      switch-preset-window-height = [];
    };

    "Mod+Minus" = {
      set-column-width = "-10%";
    };
    "Mod+Equal" = {
      set-column-width = "+10%";
    };
    "Mod+Shift+Minus" = {
      set-window-height = "-10%";
    };
    "Mod+Shift+Equal" = {
      set-window-height = "+10%";
    };

    "Mod+1" = {
      focus-workspace = 1;
    };
    "Mod+2" = {
      focus-workspace = 2;
    };
    "Mod+3" = {
      focus-workspace = 3;
    };
    "Mod+4" = {
      focus-workspace = 4;
    };
    "Mod+5" = {
      focus-workspace = 5;
    };
    "Mod+6" = {
      focus-workspace = 6;
    };
    "Mod+7" = {
      focus-workspace = 7;
    };
    "Mod+8" = {
      focus-workspace = 8;
    };
    "Mod+9" = {
      focus-workspace = 9;
    };

    "Mod+Shift+1" = {
      move-column-to-workspace = 1;
    };
    "Mod+Shift+2" = {
      move-column-to-workspace = 2;
    };
    "Mod+Shift+3" = {
      move-column-to-workspace = 3;
    };
    "Mod+Shift+4" = {
      move-column-to-workspace = 4;
    };
    "Mod+Shift+5" = {
      move-column-to-workspace = 5;
    };
    "Mod+Shift+6" = {
      move-column-to-workspace = 6;
    };
    "Mod+Shift+7" = {
      move-column-to-workspace = 7;
    };
    "Mod+Shift+8" = {
      move-column-to-workspace = 8;
    };
    "Mod+Shift+9" = {
      move-column-to-workspace = 9;
    };

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

    "Mod+Shift+WheelScrollDown" = {
      move-column-to-workspace-down = [];
    };
    "Mod+Shift+WheelScrollUp" = {
      move-column-to-workspace-up = [];
    };
    "Mod+Shift+WheelScrollRight" = {
      consume-or-expel-window-right = [];
    };
    "Mod+Shift+WheelScrollLeft" = {
      consume-or-expel-window-left = [];
    };

    "Mod+TouchpadScrollDown" = {
      focus-workspace-down = [];
    };
    "Mod+TouchpadScrollUp" = {
      focus-workspace-up = [];
    };
    "Mod+TouchpadScrollRight" = {
      focus-column-right = [];
    };
    "Mod+TouchpadScrollLeft" = {
      focus-column-left = [];
    };
    "Mod+Shift+TouchpadScrollDown" = {
      move-column-to-workspace-down = [];
    };
    "Mod+Shift+TouchpadScrollUp" = {
      move-column-to-workspace-up = [];
    };
    "Mod+Shift+TouchpadScrollRight" = {
      move-column-right = [];
    };
    "Mod+Shift+TouchpadScrollLeft" = {
      move-column-left = [];
    };

    "Mod+Print" = {
      screenshot = {
        _props.show-pointer = false;
      };
    };
    "Mod+Shift+Print" = {
      screenshot-screen = {
        _props.show-pointer = false;
      };
    };
    "Mod+Alt+Print" = {
      screenshot-window = [];
    };

    "Mod+Shift+Slash" = {
      show-hotkey-overlay = [];
    };
    "Mod+O" = {
      toggle-overview = [];
    };
    "Mod+Shift+O" = {
      toggle-window-rule-opacity = [];
    };
    "Mod+Shift+Escape" = {
      quit = {
        _props.skip-confirmation = false;
      };
    };
    "Mod+Escape" = {
      _props.allow-inhibiting = false;
      toggle-keyboard-shortcuts-inhibit = [];
    };
    "Mod+Shift+P" = {
      power-off-monitors = [];
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
      custom-shader = "
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
      custom-shader = "
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
