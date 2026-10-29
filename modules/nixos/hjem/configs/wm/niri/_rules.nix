_: {
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
        {_props.app-id._raw = ''r#"^chrome-.{32}-Default$"#'';} # helium extension's windows
        {_props.app-id._raw = ''r#"^valent$"#'';}
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
        {_props.app-id._raw = ''r#"^org.gnome.Nautilus$"#'';}
        {_props.app-id._raw = ''r#"^xdg-desktop-portal-gtk$"#'';}
        {_props.app-id._raw = ''r#"^org.github.atheriel.snapshot-explorer$"#'';}
        {_props.app-id._raw = ''r#"^app.broot$"#'';}
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
        {_props.app-id._raw = ''r#"^org.gnome.seahorse.Application$"#'';}
        {_props.app-id._raw = ''r#"^Proton Mail$"#'';}
        {_props.app-id._raw = ''r#"^Proton Pass$"#'';}
        {_props.app-id._raw = ''r#"^.protonvpn-app-wrapped$"#'';}
      ];
      block-out-from = "screen-capture";
    }
    # Floating Noctalia settings window.
    {
      match = [
        {_props.app-id._raw = ''r#"^dev.noctalia.Noctalia$"#'';}
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
  ];
}
