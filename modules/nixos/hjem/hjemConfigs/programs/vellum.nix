_: {
  flake.custom.hjemConfigs.vellum = {user, ...}: {
    hjem.users.${user} = {
      rum = {
        programs.vellum = {
          enable = true;
          systemd.enable = true;
          settings = {
            draw_on = "all";
            stroke_size = 5;
            default_tool = "pen";
            cursor.visible = true;
            clear_on_escape = false;
            default_color = "#E84046";
            remember_last_tool = true;
            feedback_duration_ms = 500;
            freeze_on_activate = false;
            annotations_visible = true;
            default_fill_shapes = false;
            whiteboard.color = "#EBEBEB";
            size_range = {
              min = 1;
              max = 100;
            };
            stops = {
              size = [];
              opacity = [];
              roundness = [];
            };
            steps = {
              size = 1;
              opacity = 0.01;
              roundness = 0.01;
            };

            palette = [
              "#E84046"
              "#EF8F4F"
              "#EED14D"
              "#4DD54F"
              "#0483FA"
              "#7C58EA"
              "#EBEBEB"
              "#141414"
            ];

            tools = {
              line = {
                opacity = 1;
                roundness = 0.5;
              };
              ellipse = {
                opacity = 1;
                filled = false;
              };
              eraser = {
                size = 10;
                cursor.visible = false;
              };
              triangle = {
                opacity = 1;
                roundness = 0.0;
                filled = false;
              };
              rectangle = {
                opacity = 1;
                roundness = 0.1;
                filled = false;
              };
              pen = {
                opacity = 1;
                roundness = 1;
                cursor.visible = false;
              };
              arrow = {
                opacity = 1;
                roundness = 0.25;
                cursor.visible = false;
              };
              text = {
                size = 16;
                opacity = 1;
                roundness = 0.1;
                steps.size = 0.5;
                background = false;
                font = {
                  family = "Maple Mono NF";
                  weight = 400;
                  style = "italic";
                  features = {
                    calt = 1; # default ligatures
                    zero = 1; # alternate zero
                    cv62 = 1; # alternative question
                    cv63 = 1; # alternative left arrow
                    cv66 = 1; # alternative pipe arrows
                    ss03 = 1; # arbitary tag
                    ss05 = 1; # thin escape backslash
                    ss07 = 1; # relax multi-greaters condition
                    ss08 = 1; # double / back rows
                    ss09 = 1; # alternative not equal
                    ss10 = 1; # aaproximately equal
                    ss11 = 1; # extra equal ligatures
                  };
                };
                size_range = {
                  min = 8;
                  max = 500;
                };
              };
            };
          };
        };
      };
    };
  };
}
