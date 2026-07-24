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
    center-focused-column = "never";

    always-center-single-column = [];

    empty-workspace-above-first = [];

    default-column-display = "normal";

    background-color = "transparent";

    gaps = 14;

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
      # Rounded corners for a modern look.
      geometry-corner-radius = [10.000000 10.000000 10.000000 10.000000];
      # Clips window contents to the rounded corner boundaries.
      clip-to-geometry = true;

      background-effect = {
        blur = true;
        xray = false;
      };

      popups = {
        geometry-corner-radius = 15;
        opacity = 0.750000;
        background-effect = {
          blur = true;
          xray = false;
        };
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
        {_props.app-id._raw = ''r#"^org\.kde\.kdeconnect-indicator$"#'';}
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
        {_props.app-id._raw = ''r#"^dev\.lemmy\.swash$"#'';}
        {_props.app-id._raw = ''r#"^pqiv$"#'';}
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
        {_props.app-id._raw = ''r#"^org\.gnome\.Nautilus$"#'';}
        {_props.app-id._raw = ''r#"^xdg-desktop-portal-gtk$"#'';}
        {_props.app-id._raw = ''r#"^app\.ns$"#'';}
        {_props.app-id._raw = ''r#"^app\.yazi$"#'';}
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
    # windows to be blocked out from screen-capture
    {
      match = [
        {_props.app-id._raw = ''r#"^org\.gnome\.seahorse\.Application$"#'';}
        {_props.app-id._raw = ''r#"^Proton Mail$"#'';}
        {_props.app-id._raw = ''r#"^Proton Pass$"#'';}
        {_props.app-id._raw = ''r#"^\.protonvpn-app-wrapped$"#'';}
      ];
      block-out-from = "screen-capture";
    }
    # Floating Noctalia settings window.
    {
      match = [
        {_props.app-id._raw = ''r#"^dev\.noctalia\.Noctalia\.Settings$"#'';}
      ];
      open-floating = true;
      default-column-width._children = [
        {fixed = 1080;}
      ];
      default-window-height._children = [
        {fixed = 920;}
      ];
    }
  ];

  layer-rule = [
    # noctalia
    # blur wallpaper
    {
      match = [
        {_props.namespace._raw = ''r#"^noctalia-backdrop$"#'';}
      ];
      place-within-backdrop = true;
    }
    # Disable xray on all our surfaces so it looks more realistic.
    {
      match = [
        {_props.namespace._raw = ''r#"^noctalia-(bar-[^\"]+|notification|panel|attached-panel|osd)$"#'';}
      ];
      background-effect = {
        blur = true;
        xray = false;
      };
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
    []
    []
  ];

  binds = let
    hotkey = color: name: text: ''<span foreground='${color}'>[${name}]</span> ${text}'';
  in {
    # Noctalia
    "Mod+Space" = {
      _props.hotkey-overlay-title = "${hotkey "#BE9DB8" "󰖔  Noctalia" "Launcher"}";
      spawn = ["noctalia" "msg" "panel-toggle" "launcher"];
    };
    "Mod+N" = {
      _props.hotkey-overlay-title = "${hotkey "#BE9DB8" "󰖔  Noctalia" "Notes"}";
      spawn = ["noctalia" "msg" "panel-toggle" "noctalia/notes:panel"];
    };
    "Mod+S" = {
      _props.hotkey-overlay-title = "${hotkey "#BE9DB8" "󰖔  Noctalia" "Control Center"}";
      spawn = ["noctalia" "msg" "panel-toggle" "control-center"];
    };
    "Mod+W" = {
      _props.hotkey-overlay-title = "${hotkey "#BE9DB8" "󰖔  Noctalia" "Wallpaper"}";
      spawn = ["noctalia" "msg" "panel-toggle" "wallpaper"];
    };
    "Mod+Shift+W" = {
      _props.hotkey-overlay-title = "${hotkey "#BE9DB8" "󰖔  Noctalia" "Video Wallpaper"}";
      spawn = ["noctalia" "msg" "panel-toggle" "noctalia/mpvpaper:picker"];
    };
    "Mod+X" = {
      _props.hotkey-overlay-title = "${hotkey "#BE9DB8" "󰖔  Noctalia" "Session"}";
      spawn = ["noctalia" "msg" "panel-toggle" "session"];
    };
    "Mod+Y" = {
      _props.hotkey-overlay-title = "${hotkey "#BE9DB8" "󰖔  Noctalia" "Clipboard"}";
      spawn = ["noctalia" "msg" "panel-toggle" "clipboard"];
    };
    "Mod+Comma" = {
      _props.hotkey-overlay-title = "${hotkey "#BE9DB8" "󰖔  Noctalia" "Settings"}";
      spawn = ["noctalia" "msg" "settings-toggle"];
    };
    "Print" = {
      _props.hotkey-overlay-title = "${hotkey "#BE9DB8" "󰖔  Noctalia" "Screenshot Region"}";
      spawn = ["noctalia" "msg" "screenshot-region"];
    };
    "Shift+Print" = {
      _props.hotkey-overlay-title = "${hotkey "#BE9DB8" "󰖔  Noctalia" "Screenshot Fullscreen"}";
      spawn = ["noctalia" "msg" "screenshot-fullscreen pick"];
    };

    # media-key
    "XF86AudioRaiseVolume" = {
      _props.allow-when-locked = true;
      spawn = ["noctalia" "msg" "volume-up"];
    };
    "XF86AudioLowerVolume" = {
      _props.allow-when-locked = true;
      spawn = ["noctalia" "msg" "volume-down"];
    };
    "XF86AudioMute" = {
      _props.allow-when-locked = true;
      spawn = ["noctalia" "msg" "volume-mute"];
    };
    "XF86AudioPlay" = {
      _props.allow-when-locked = true;
      spawn = ["noctalia" "msg" "media" "toggle"];
    };
    "XF86AudioPrev" = {
      _props.allow-when-locked = true;
      spawn = ["noctalia" "msg" "media" "previous"];
    };
    "XF86AudioNext" = {
      _props.allow-when-locked = true;
      spawn = ["noctalia" "msg" "media" "next"];
    };
    "XF86MonBrightnessUp" = {
      _props.allow-when-locked = true;
      spawn = ["noctalia" "msg" "brightness-up"];
    };
    "XF86MonBrightnessDown" = {
      _props.allow-when-locked = true;
      spawn = ["noctalia" "msg" "brightness-down"];
    };

    # execute
    "Mod+Return" = {
      _props.hotkey-overlay-title = "${hotkey "#5E81AC" "󰊠  Ghostty" "Terminal Emulator"}";
      spawn = ["ghostty" "+new-window"];
    };
    "Mod+B" = {
      _props.hotkey-overlay-title = "${hotkey "#5E81AC" "  Helium" "Web Browser"}";
      spawn = ["helium"];
    };
    "Mod+D" = {
      _props.hotkey-overlay-title = "${hotkey "#5E81AC" "  WebCord" "Discord Client"}";
      spawn = ["webcord"];
    };
    "Mod+Shift+N" = {
      _props.hotkey-overlay-title = "${hotkey "#5E81AC" "󱄅  Nix Search" "Nix Package"}";
      spawn = ["ghostty" "--class=app.ns" "-e" "ns"];
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
    "Alt+Print" = {screenshot-window = [];};
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
      duration-ms = 150;
      curve = "linear";
      custom-shader =
        # glsl
        ''
          vec4 open_color(vec3 coords_geo, vec3 size_geo) {
              if (coords_geo.x < 0.0 || coords_geo.x > 1.0 ||
                  coords_geo.y < 0.0 || coords_geo.y > 1.0) {
                      return vec4(0.0);
                  }

              const float PI = 3.14;
              float p = sin(niri_clamped_progress * (PI/2.0) );
              float radius = mix(0.05,0.0, p);
              const float samples = 7.0;

              vec4 outColor = vec4(0.0);

              // Define a constant for 2 * PI (tau), which represents a full circle in radians.
              const float tau = 6.28318530718;

              // Number of directions for sampling around the circle.
              const float directions = 11.0;

              vec3 coords_tex = niri_geo_to_tex * coords_geo;

              // Outer loop iterates over multiple directions evenly spaced around a circle.
              for (float d = 0.0; d < tau; d += tau / directions) {
                  // Inner loop samples along each direction, with decreasing intensity.
                  for (float s = 0.0; s < 1.0; s += 1.0 / samples) {
                      // Calculate the offset for this sample based on direction, radius, and step.
                      // The (1.0 - s) term ensures more sampling occurs closer to the center.
                      vec2 offset = vec2(cos(d), sin(d)) * radius * (1.0 - s) / coords_geo.xy;

                      // Add the sampled color at the offset position to the accumulator.
                      outColor += texture2D(niri_tex, coords_tex.st + offset);
                  }
              }

              // Normalize the accumulated color by dividing by the total number of samples
              // and directions to ensure the result is averaged.
              return (outColor / samples / directions) * p;
          }
        '';
    };

    window-close = {
      duration-ms = 150;
      curve = "linear";
      custom-shader =
        # glsl
        ''
          vec4 close_color(vec3 coords_geo, vec3 size_geo) {
              if (coords_geo.x < 0.0 || coords_geo.x > 1.0 ||
                  coords_geo.y < 0.0 || coords_geo.y > 1.0) {
                      return vec4(0.0);
              }

              const float PI = 3.14;
              float p = sin(niri_clamped_progress * (PI/2.0) );

              float radius = mix(0.0,0.05, p);
              const float samples = 7.0;

              vec4 outColor = vec4(0.0);

              // Define a constant for 2 * PI (tau), which represents a full circle in radians.
              const float tau = 6.28318530718;

              // Number of directions for sampling around the circle.
              const float directions = 11.0;

              vec3 coords_tex = niri_geo_to_tex * coords_geo;

              // Outer loop iterates over multiple directions evenly spaced around a circle.
              for (float d = 0.0; d < tau; d += tau / directions) {
                  // Inner loop samples along each direction, with decreasing intensity.
                  for (float s = 0.0; s < 1.0; s += 1.0 / samples) {
                      // Calculate the offset for this sample based on direction, radius, and step.
                      // The (1.0 - s) term ensures more sampling occurs closer to the center.
                      vec2 offset = vec2(cos(d), sin(d)) * radius * (1.0 - s) / coords_geo.xy;

                      // Add the sampled color at the offset position to the accumulator.
                      outColor += texture2D(niri_tex, coords_tex.st + offset);
                  }
              }

              // Normalize the accumulated color by dividing by the total number of samples
              // and directions to ensure the result is averaged.

              return (outColor / samples / directions) * (1.0 - p);
          }
        '';
    };

    window-resize = {
      duration-ms = 400;
      curve = "linear";
      custom-shader =
        # glsl
        ''
          float easeInOutSine(float t) {
              return -0.5 * (cos(3.141592653589793 * t) - 1.0);
          }

          vec4 resize_color(vec3 coords_geo, vec3 size_geo) {
              if (coords_geo.x < 0.0 || coords_geo.x > 1.0 ||
                  coords_geo.y < 0.0 || coords_geo.y > 1.0) {
                  return vec4(0.0);
              }

              const float PI = 3.14;
              float p = easeInOutSine ( sin(niri_clamped_progress * PI ));

              float radius = mix(0.0,0.0025, p);
              const float samples = 7.0;

              vec4 outColor = vec4(0.0);

              // Define a constant for 2 * PI (tau), which represents a full circle in radians.
              const float tau = 6.28318530718;

              // Number of directions for sampling around the circle.
              const float directions = 11.0;

              // Outer loop iterates over multiple directions evenly spaced around a circle.
              for (float d = 0.0; d < tau; d += tau / directions) {
                  // Inner loop samples along each direction, with decreasing intensity.
                  for (float s = 0.0; s < 1.0; s += 1.0 / samples) {
                      // Calculate the offset for this sample based on direction, radius, and step.
                      // The (1.0 - s) term ensures more sampling occurs closer to the center.
                      vec2 offset = vec2(cos(d), sin(d)) * radius * (1.0 - s) / coords_geo.xy;

                      outColor += texture2D(niri_tex_next, coords_geo.st + offset );
                  }
              }

              // Normalize the accumulated color by dividing by the total number of samples
              // and directions to ensure the result is averaged.
              outColor = outColor / samples / directions;
              outColor.a = 1.0;
              return outColor ;
          }
        '';
    };

    workspace-switch = {
      spring._props = {
        damping-ratio = 1.0;
        stiffness = 760;
        epsilon = 0.0001;
      };
    };

    horizontal-view-movement = {
      spring._props = {
        damping-ratio = 1.0;
        stiffness = 640;
        epsilon = 0.0001;
      };
    };

    window-movement = {
      spring._props = {
        damping-ratio = 1.0;
        stiffness = 700;
        epsilon = 0.0001;
      };
    };

    config-notification-open-close = {
      spring._props = {
        damping-ratio = 1.0;
        stiffness = 820;
        epsilon = 0.001;
      };
    };

    screenshot-ui-open = {
      duration-ms = 220;
      curve = [
        {
          _args = [
            "cubic-bezier"
            0.22
            1.0
            0.36
            1.0
          ];
        }
      ];
    };

    overview-open-close = {
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
    passes = 2;
    offset = 3.0;
    noise = 0.03;
    saturation = 1.0;
  };

  include = [
    [
      {
        _args = ["noctalia.kdl"];
        _props = {
          optional = true;
        };
      }
    ]
  ];

  debug = {
    # Allows notification actions and window activation from Noctalia.
    honor-xdg-activation-with-invalid-serial = [];
  };
}
