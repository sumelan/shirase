_: {
  programs.niri.settings.animations = {
    enable = true;
    slowdown = 2.0;
    window-open = {
      kind.easing = {
        curve = "linear";
        duration-ms = 200;
      };
      custom-shader =
        # glsl
        ''
          vec4 expanding_circle(vec3 coords_geo, vec3 size_geo) {
              vec3 coords_tex = niri_geo_to_tex * coords_geo;
              vec4 color = texture2D(niri_tex, coords_tex.st);
              vec2 coords = (coords_geo.xy - vec2(0.5, 0.5)) * size_geo.xy * 2.0;
              coords = coords / length(size_geo.xy);
              float p = niri_clamped_progress;
              if (p * p <= dot(coords, coords))
              color = vec4(0.0);
              return color;
          }

          vec4 open_color(vec3 coords_geo, vec3 size_geo) {
              return expanding_circle(coords_geo, size_geo);
          }
        '';
    };
    window-close = {
      kind.easing = {
        curve = "linear";
        duration-ms = 300;
      };
      custom-shader =
        # glsl
        ''
          vec4 fall_and_rotate(vec3 coords_geo, vec3 size_geo) {
              float progress = niri_clamped_progress * niri_clamped_progress;
              vec2 coords = (coords_geo.xy - vec2(0.5, 1.0)) * size_geo.xy;
          	  coords.y -= progress * 4440.0;
          	  float max_angle = -0.8;
          	  float angle = progress * max_angle;
          	  mat2 rotate = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
          	  coords = rotate * coords;
          	  coords_geo = vec3(coords / size_geo.xy + vec2(0.5, 1.0), 1.0);
          	  vec3 coords_tex = niri_geo_to_tex * coords_geo;
          	  vec4 color = texture2D(niri_tex, coords_tex.st);
              return color;
          }

          vec4 close_color(vec3 coords_geo, vec3 size_geo) {
              return fall_and_rotate(coords_geo, size_geo);
          }
        '';
    };
    window-resize = {
      kind.spring = {
        damping-ratio = 0.6;
        stiffness = 800;
        epsilon = 0.0001;
      };
    };
    window-movement = {
      kind.spring = {
        damping-ratio = 0.8;
        stiffness = 600;
        epsilon = 0.0001;
      };
    };
    workspace-switch = {
      kind.spring = {
        damping-ratio = 0.7;
        stiffness = 700;
        epsilon = 0.0001;
      };
    };
    horizontal-view-movement = {
      kind.spring = {
        damping-ratio = 0.8;
        stiffness = 600;
        epsilon = 0.0001;
      };
    };
  };
}
