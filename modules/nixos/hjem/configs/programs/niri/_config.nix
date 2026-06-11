{
  config,
  lib,
  pkgs,
  user,
  ...
}: let
  inherit (config.lib.custom.hardware.monitors) mainMonitor mainMonitorName;
in {
  hotkey-overlay = {
    skip-at-startup = [];
    hide-not-bound = [];
  };

  overview = {
    zoom = 0.500000;
    backdrop-color = "#3B4252";
    workspace-shadow = {color = "#3B4252" + "90";};
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
          from = "#B1C89D";
          to = "#9FC6C5";
          angle = 45;
          "in" = "oklch longer hue";
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
      color = "#191D24" + "90";
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
      active-color = "#191D24" + "90";
      inactive-color = "#434C5E" + "90";
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
      opacity = 0.850000;
      background-effect = {
        xray = true;
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
      opacity = 0.820000;
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
            from = "#D79784";
            to = "#C5727A";
            angle = 45;
            "in" = "oklch longer hue";
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
        color = "#ECEFF4" + "90";
      };
      tab-indicator = {
        active-color = "#C5727A";
        inactive-color = "#434C5E";
      };
    }
    # windows wanted to be floating
    {
      match = [
        {_props.app-id._raw = ''r#"^.blueman-manager-wrapped$"#'';}
        {_props.app-id._raw = ''r#"^chrome-"#'';} # helium extension's windows
        {_props.app-id._raw = ''r#"^org.kde.kdeconnect-indicator$"#'';}
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
        {_props.app-id._raw = ''r#"^com.gabm.satty$"#'';}
        {_props.app-id._raw = ''r#"^dissent$"#'';}
        {_props.app-id._raw = ''r#"^swayimg$"#'';}
        {_props.app-id._raw = ''r#"^vlc$"#'';}
      ];
      default-column-width._children = [
        {proportion = 0.450000;}
      ];
      default-window-height._children = [
        {proportion = 0.450000;}
      ];
      open-floating = true;
      opacity = 1.000000;
    }
    # windows wanted to be floating and be blocked out from screen-capture
    {
      match = [
        {_props.app-id._raw = ''r#"^org.gnome.Nautilus$"#'';}
        {_props.app-id._raw = ''r#"^xdg-desktop-portal-gtk$"#'';}
        {_props.app-id._raw = ''r#"^app.yazi$"#'';}
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
    # windows to be blocked out from screen-capture
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
    # dms: block out sensitive components from screen-capture
    {
      match = [
        {_props.namespace._raw = ''r#"^dms:clipboard$"#'';}
      ];
      block-out-from = "screen-capture";
    }
    # wlr-which-key
    {
      match = [
        {_props.namespace._raw = ''r#"^wlr_which_key$"#'';}
      ];
      opacity = 0.850000;
      background-effect = {
        blur = true;
        xray = true;
      };
    }
  ];

  spawn-at-startup = [
    ["nm-applet"]
    ["blueman-applet"]
  ];

  binds = let
    hotkey = color: name: text: ''<span foreground='${color}'>[${name}]</span> ${text}'';
  in {
    # dms
    "Mod+Space" = {
      _props.hotkey-overlay-title = "${hotkey "#BE9DB8" "󰮤  DankMaterialShell" "Spotlight Bar"}";
      spawn = ["dms" "ipc" "spotlight-bar" "toggle"];
    };
    "Mod+Y" = {
      _props.hotkey-overlay-title = "${hotkey "#BE9DB8" "󰮤  DankMaterialShell" "Clipboard"}";
      spawn = ["dms" "ipc" "clipboard" "toggle"];
    };
    "Mod+X" = {
      _props.hotkey-overlay-title = "${hotkey "#BE9DB8" "󰮤  DankMaterialShell" "Powermenu"}";
      spawn = ["dms" "ipc" "powermenu" "toggle"];
    };
    "Mod+S" = {
      _props = {
        cooldown-ms = 500;
        hotkey-overlay-title = "${hotkey "#BE9DB8" "󰮤  DankMaterialShell" "DMS Keychord"}";
      };
      spawn = ["wlr-which-key" "--initial-keys" "d"];
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
    # screenshot
    "Mod+Backslash" = {
      _props.hotkey-overlay-title = "${hotkey "#BE9DB8" "󰮤  DankMaterialShell" "Interactive selection screenshot"}";
      spawn = ["dms" "ipc" "niri" "screenshot"];
    };
    "Mod+Shift+Backslash" = {
      _props.hotkey-overlay-title = "${hotkey "#BE9DB8" "󰮤  DankMaterialShell" "Capture entire screen"}";
      spawn = ["dms" "ipc" "niri" "screenshotScreen"];
    };
    "Mod+Alt+Backslash" = {
      _props.hotkey-overlay-title = "${hotkey "#BE9DB8" "󰮤  DankMaterialShell" "Capture focused window"}";
      spawn = ["dms" "ipc" "niri" "screenshotWindow"];
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
      _props.hotkey-overlay-title = "${hotkey "#81A1C1" "󰊠  Ghostty" "Terminal Emulator"}";
      spawn = ["ghostty" "+new-window"];
    };
    "Mod+B" = {
      _props.hotkey-overlay-title = "${hotkey "#5E81AC" "  Helium" "Web Browser"}";
      spawn-sh = "helium &";
    };
    "Mod+N" = {
      _props = {
        cooldown-ms = 500;
        hotkey-overlay-title = "${hotkey "#D79784" "󰗢  niri" "niri Keychord"}";
      };
      spawn = ["wlr-which-key" "--initial-keys" "n"];
    };
    "Mod+D" = {
      _props.hotkey-overlay-title = "${hotkey "#5E81AC" "  Dissent" "Discord Client"}";
      spawn = ["dissent"];
    };
    "Mod+Shift+N" = {
      _props.hotkey-overlay-title = "${hotkey "#5E81AC" "󱄅  Nix Search" "Nix Package"}";
      spawn = ["ghostty" "--class=dev.vlinkz.NixosConfEditor" "-e" "ns"];
    };
    "Mod+Shift+Y" = {
      _props.hotkey-overlay-title = "${hotkey "#E7C173" "󰇥  Yazi" "File Manager"}";
      spawn = ["ghostty" "--class=app.yazi" "-e" "yazi"];
    };
    "Ctrl+Space" = {
      _props.hotkey-overlay-title = "${hotkey "#A3BE8C" "󰗊  Hazkey" "Switch input method"}";
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
      active-color = "#8CAAEE" + "FF";
      urgent-color = "#EA999C" + "FF";
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
    # Slow down all animations by this factor. Values below 1 speed them up instead.
    slowdown = 1.0;

    window-open = {
      duration-ms = 260;
      # curve "linear"
      # curve "cubic-bezier" 1.0 0.00 0.795 0.035
      curve = "linear";
      custom-shader =
        # glsl
        ''
          // =========================
          // Exponential
          // =========================
          float easeInExpo(float t) {
              return t == 0.0 ? 0.0 : pow(2.0, 10.0 * (t - 1.0));
          }

          float easeOutExpo(float t) {
              return t == 1.0 ? 1.0 : 1.0 - pow(2.0, -10.0 * t);
          }

          float easeInOutExpo(float t) {
              if (t == 0.0) return 0.0;
              if (t == 1.0) return 1.0;
              return t < 0.5
                  ? 0.5 * pow(2.0, 20.0 * t - 10.0)
                  : 1.0 - 0.5 * pow(2.0, -20.0 * t + 10.0);
          }

          // =========================
          // Sine
          // =========================
          float easeInSine(float t) {
              return 1.0 - cos((t * 3.141592653589793) / 2.0);
          }

          float easeOutSine(float t) {
              return sin((t * 3.141592653589793) / 2.0);
          }

          float easeInOutSine(float t) {
              return -0.5 * (cos(3.141592653589793 * t) - 1.0);
          }

          // =========================
          // Quadratic
          // =========================
          float easeInQuad(float t) {
              return t * t;
          }

          float easeOutQuad(float t) {
              return 1.0 - (1.0 - t) * (1.0 - t);
          }

          float easeInOutQuad(float t) {
              return t < 0.5
                  ? 2.0 * t * t
                  : 1.0 - pow(-2.0 * t + 2.0, 2.0) / 2.0;
          }

          // =========================
          // Cubic
          // =========================
          float easeInCubic(float t) {
              return t * t * t;
          }

          float easeOutCubic(float t) {
              float f = t - 1.0;
              return f * f * f + 1.0;
          }

          float easeInOutCubic(float t) {
              return t < 0.5
                  ? 4.0 * t * t * t
                  : 1.0 - pow(-2.0 * t + 2.0, 3.0) / 2.0;
          }

          //---

          float saturate(float x) {
              return clamp(x, 0.0, 1.0);
          }

          vec2 scaleUV(vec2 uv, vec2 scale) {
              return (uv - 0.5) / scale + 0.5;
          }

          float centerGradient(float x) {
              x = x * 2.0;
              return x < 1.0 ? x : 2.0 - x;
          }

          vec4 open_color(vec3 coords_geo, vec3 size_geo) {

              vec2 uv = (niri_geo_to_tex * coords_geo).xy;

              if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
                  return vec4(0.0);
              }

              float t = easeOutQuad(niri_clamped_progress);

              float x = mix(0.1,1.0,easeOutCubic(niri_clamped_progress));
              float y = easeInQuad(niri_clamped_progress);

              vec2 suv = scaleUV(uv, vec2(x, y));

              if (suv.x < 0.0 || suv.x > 1.0 || suv.y < 0.0 || suv.y > 1.0) {
                  return vec4(0.0);
              }

              // Soft edge masks inspired by the BMW shader's center gradients.
              float tb = centerGradient(suv.y);
              float lr = centerGradient(suv.x);

              float tbMask = smoothstep(0.0, 0.10, tb);
              float lrMask = smoothstep(0.0, 0.10, lr);

              float mask = tbMask * lrMask;

              // Cool startup tint.
              vec3 tint = vec3(0.55, 0.82, 1.0);
              vec3 color = mix(tint, vec3(1.0), t);

              // Stronger tint at the beginning.
              float tintAmt = smoothstep(0.0, 0.8, t);

              vec3 rgb = mix(tint, color, tintAmt);
              float alpha = mask * t;

              //gets the window color
              vec4 wColor = texture2D(niri_tex, suv) ;

              //returns the final color
              return mix(vec4(rgb, alpha * wColor.a),wColor, easeInExpo( niri_clamped_progress));

          }
        '';
    };

    window-close = {
      duration-ms = 180;
      # curve "linear"
      # curve "ease-out-expo"
      curve = "linear";
      custom-shader =
        # glsl
        ''
          // =========================
          // Exponential
          // =========================
          float easeInExpo(float t) {
              return t == 0.0 ? 0.0 : pow(2.0, 10.0 * (t - 1.0));
          }

          float easeOutExpo(float t) {
              return t == 1.0 ? 1.0 : 1.0 - pow(2.0, -10.0 * t);
          }

          float easeInOutExpo(float t) {
              if (t == 0.0) return 0.0;
              if (t == 1.0) return 1.0;
              return t < 0.5
                  ? 0.5 * pow(2.0, 20.0 * t - 10.0)
                  : 1.0 - 0.5 * pow(2.0, -20.0 * t + 10.0);
          }

          // =========================
          // Sine
          // =========================
          float easeInSine(float t) {
              return 1.0 - cos((t * 3.141592653589793) / 2.0);
          }

          float easeOutSine(float t) {
              return sin((t * 3.141592653589793) / 2.0);
          }

          float easeInOutSine(float t) {
              return -0.5 * (cos(3.141592653589793 * t) - 1.0);
          }

          // =========================
          // Quadratic
          // =========================
          float easeInQuad(float t) {
              return t * t;
          }

          float easeOutQuad(float t) {
              return 1.0 - (1.0 - t) * (1.0 - t);
          }

          float easeInOutQuad(float t) {
              return t < 0.5
                  ? 2.0 * t * t
                  : 1.0 - pow(-2.0 * t + 2.0, 2.0) / 2.0;
          }

          // =========================
          // Cubic
          // =========================
          float easeInCubic(float t) {
              return t * t * t;
          }

          float easeOutCubic(float t) {
              float f = t - 1.0;
              return f * f * f + 1.0;
          }

          float easeInOutCubic(float t) {
              return t < 0.5
                  ? 4.0 * t * t * t
                  : 1.0 - pow(-2.0 * t + 2.0, 3.0) / 2.0;
          }

          //---

          float saturate(float x) {
              return clamp(x, 0.0, 1.0);
          }

          vec2 scaleUV(vec2 uv, vec2 scale) {
              return (uv - 0.5) / scale + 0.5;
          }

          float centerGradient(float x) {
              x = x * 2.0;
              return x < 1.0 ? x : 2.0 - x;
          }

          vec4 close_color(vec3 coords_geo, vec3 size_geo) {
              if (coords_geo.x < 0.0 || coords_geo.x > 1.0 ||
                  coords_geo.y < 0.0 || coords_geo.y > 1.0) {
                  return vec4(0.0);
              }

              vec2 uv = (niri_geo_to_tex * coords_geo).xy;

              if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
                  return vec4(0.0);
              }

              float t = easeOutQuad(1.0 - niri_clamped_progress);

              float x = mix(0.1,1.0,easeOutCubic(1.0 - niri_clamped_progress));
              float y = easeInQuad(1.0 - niri_clamped_progress);

              vec2 suv = scaleUV(uv, vec2(x, y));

              if (suv.x < 0.0 || suv.x > 1.0 || suv.y < 0.0 || suv.y > 1.0) {
                  return vec4(0.0);
              }

              // Soft edge masks inspired by the BMW shader's center gradients.
              float tb = centerGradient(suv.y);
              float lr = centerGradient(suv.x);

              float tbMask = smoothstep(0.0, 0.10, tb);
              float lrMask = smoothstep(0.0, 0.10, lr);

              float mask = tbMask * lrMask;

              // Cool startup tint.
              vec3 tint = vec3(0.55, 0.82, 1.0);
              vec3 color = mix(tint, vec3(1.0), t);

              // Stronger tint at the beginning.
              float tintAmt = smoothstep(0.0, 0.8, t);

              vec3 rgb = mix(tint, color, tintAmt);
              float alpha = mask * t;

              //gets the window color
              vec4 wColor = texture2D(niri_tex, suv) ;

              //returns the final color
              return mix(vec4(rgb, alpha * wColor.a),wColor, easeInExpo( 1.0 - niri_clamped_progress));
          }
        '';
    };

    window-resize = {
      duration-ms = 160;
      curve = "linear";
      # curve "cubic-bezier" 0.95 0.05 0.795 0.035

      custom-shader =
        # glsl
        ''
          const float PI = 3.141592653589793;

          float hash21(vec2 p) {
              p = fract(p * vec2(127.1, 311.7));
              p += dot(p, p + 34.345);
              return fract(p.x * p.y);
          }

          float noise2(vec2 uv) {
              vec2 i = floor(uv);
              vec2 f = fract(uv);

              float a = hash21(i);
              float b = hash21(i + vec2(1.0, 0.0));
              float c = hash21(i + vec2(0.0, 1.0));
              float d = hash21(i + vec2(1.0, 1.0));

              vec2 u = f * f * (3.0 - 2.0 * f);

              return mix(a, b, u.x)
                  + (c - a) * u.y * (1.0 - u.x)
                  + (d - b) * u.x * u.y;
          }

          vec3 randomRGB(vec2 uv, float t) {
              // Independent noise per channel → real CRT chaos
              float r = noise2(uv * 1.3 + vec2(13.0, 71.0) + t * 120.0);
              float g = noise2(uv * 1.7 + vec2(37.0, 19.0) + t * 90.0);
              float b = noise2(uv * 1.1 + vec2(91.0, 53.0) + t * 140.0);
              return vec3(r, g, b);
          }

          vec4 resize_color(vec3 coords_geo, vec3 size_geo) {
              if (coords_geo.x < 0.0 || coords_geo.x > 1.0 ||
                  coords_geo.y < 0.0 || coords_geo.y > 1.0) {
                  return vec4(0.0);
              }

              vec2 uv = coords_geo.xy;
              float t = niri_clamped_progress;

              // Strongest mid-animation
              float pulse = sin(t * PI);

              // Multi-scale noise layers (coarse + fine)
              vec2 base = uv * size_geo.xy;

              vec3 coarse = randomRGB(floor(base * 0.12), t);
              vec3 mid    = randomRGB(base * 0.35, t);
              vec3 fine   = randomRGB(base * 0.9,  t);

              // Combine for richer randomness
              vec3 snow = mix(coarse, mid, 0.5);
              snow = mix(snow, fine, 0.35);

              // Center around 0
              snow -= 0.5;

              // Add subtle horizontal interference streaks
              float streak = sin(uv.y * size_geo.y * 0.6 + t * 80.0) * 0.15;
              snow += vec3(streak);

              // Slight color bias flicker
              vec3 tint = vec3(
                  sin(t * 37.0) * 0.2,
                  sin(t * 53.0) * 0.2,
                  sin(t * 29.0) * 0.2
              );

              snow += tint;

              // Final intensity
              float strength = 0.55;
              vec4 color = vec4(snow,1.0) * strength * pulse;
              color.a = 1.0;

              float alpha = length(color) * 1.2;

              vec3 coords_tex_next = niri_geo_to_tex_next * coords_geo;
              vec4 wColor = texture2D(niri_tex_next, coords_tex_next.st );

              return mix(wColor, color, pulse * 0.5);
          }
        '';
    };

    workspace-switch = {
      # Smooth, composed, no bounce.
      spring._props = {
        damping-ratio = 1.0;
        stiffness = 760;
        epsilon = 0.0001;
      };
    };

    horizontal-view-movement = {
      # Main "camera glide" for scrollable movement.
      spring._props = {
        damping-ratio = 1.0;
        stiffness = 640;
        epsilon = 0.0001;
      };
    };

    window-movement = {
      # Individual windows shift with a slightly tighter response
      # than the camera, so it feels organized.
      spring._props = {
        damping-ratio = 1.0;
        stiffness = 700;
        epsilon = 0.0001;
      };
    };

    config-notification-open-close = {
      # Less playful, more refined than the default underdamped feel.
      spring._props = {
        damping-ratio = 1.0;
        stiffness = 820;
        epsilon = 0.001;
      };
    };

    exit-confirmation-open-close = {
      spring._props = {
        damping-ratio = 1.0;
        stiffness = 560;
        epsilon = 0.01;
      };
    };

    screenshot-ui-open = {
      duration-ms = 220;
      curve = ["cubic-bezier" 0.22 1.0 0.36 1.0];
    };

    overview-open-close = {
      # Overview should feel smooth and premium, not springy/bouncy.
      spring._props = {
        damping-ratio = 1.0;
        stiffness = 620;
        epsilon = 0.0001;
      };
    };

    recent-windows-close = {
      spring._props = {
        damping-ratio = 1.0;
        stiffness = 680;
        epsilon = 0.001;
      };
    };
  };

  prefer-no-csd = [];

  screenshot-path = "${config.hjem.users.${user}.directory}/Pictures/Screenshots/screenshot_%Y-%m-%d_%H-%M-%S.png";

  xwayland-satellite = let
    # xwayland
    xwayland =
      if config.custom.programs.niri.xwayland
      then {
        path = lib.getExe pkgs.xwayland-satellite;
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
