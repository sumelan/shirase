{config, ...}: {
  hjem.users.sumelan.rum = {
    wayland.windowManager.niri.settings = let
      cfg = config.custom.wayland.windowManager.niri;
    in {
      window-rule =
        [
          # all windows
          {
            draw-border-with-background = false;
            # Rounded corners for a modern look.
            geometry-corner-radius = 12;
            # Clips window contents to the rounded corner boundaries.
            clip-to-geometry = true;

            background-effect = {
              blur = true;
            };

            popups = {
              geometry-corner-radius = 15;
              opacity = 0.750000;
              background-effect = {
                blur = true;
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
            opacity = 0.830000;
          }
          # floating but not focused
          {
            match = {
              _props = {
                is-floating = true;
                is-focused = false;
              };
            };
            opacity = 0.630000;
          }
          # not floating but focused
          {
            match = {
              _props = {
                is-floating = false;
                is-focused = true;
              };
            };
            focus-ring = {width = 3.5;};
            opacity = 0.800000;
          }
          # not floating nor focused
          {
            match = {
              _props = {
                is-floating = false;
                is-focused = false;
              };
            };
            opacity = 0.480000;
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
          {
            match = [
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
          # windows to be blocked out from screen-capture
          {
            match = [
              {_props.app-id._raw = ''r#"^org.gnome.seahorse.Application$"#'';}
            ];
            block-out-from = "screen-capture";
          }
        ]
        ++ cfg.extraWindow-rule;
      layer-rule =
        []
        ++ cfg.extraLayer-rule;
    };
  };
}
