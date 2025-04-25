_: {
  programs.niri.settings.animations = {
    window-open = {
      spring = {
        damping-ratio = 0.7;
        stiffness = 300;
        epsilon = 0.001;
      };
    };
    window-close = {
      easing = {
        curve = "ease-out-quad";
        duration-ms = 500;
      };
    };
    workspace-switch = {
      spring = {
        damping-ratio = 0.8;
        stiffness = 600;
        epsilon = 0.001;
      };
    };
    horizontal-view-movement = {
      spring = {
        damping-ratio = 1.0;
        stiffness = 600;
        epsilon = 0.001;
      };
    };
    window-movement = {
      spring = {
        damping-ratio = 1.0;
        stiffness = 600;
        epsilon = 0.001;
      };
    };
    shaders = {
      window-open =
        # glsl
        ''
          // Example: fill the current geometry with a solid vertical gradient and
          // gradually make opaque.
          vec4 solid_gradient(vec3 coords_geo, vec3 size_geo) {
              vec4 color = vec4(0.0);

              // Paint only the area inside the current geometry.
              if (0.0 <= coords_geo.x && coords_geo.x <= 1.0
                      && 0.0 <= coords_geo.y && coords_geo.y <= 1.0)
              {
                  vec4 from = vec4(1.0, 0.0, 0.0, 1.0);
                  vec4 to = vec4(0.0, 1.0, 0.0, 1.0);
                  color = mix(from, to, coords_geo.y);
              }

              // Make it opaque.
              color *= niri_clamped_progress;

              return color;
          }

          // Example: gradually scale up and make opaque, equivalent to the default
          // opening animation.
          vec4 default_open(vec3 coords_geo, vec3 size_geo) {
              // Scale up the window.
              float scale = max(0.0, (niri_progress / 2.0 + 0.5));
              coords_geo = vec3((coords_geo.xy - vec2(0.5)) / scale + vec2(0.5), 1.0);

              // Get color from the window texture.
              vec3 coords_tex = niri_geo_to_tex * coords_geo;
              vec4 color = texture2D(niri_tex, coords_tex.st);

              // Make the window opaque.
              color *= niri_clamped_progress;

              return color;
          }

          // Example: show the window as an expanding circle.
          // Recommended setting: duration-ms 250
          vec4 expanding_circle(vec3 coords_geo, vec3 size_geo) {
              vec3 coords_tex = niri_geo_to_tex * coords_geo;
              vec4 color = texture2D(niri_tex, coords_tex.st);

              vec2 coords = (coords_geo.xy - vec2(0.5, 0.5)) * size_geo.xy * 2.0;
              coords = coords / length(size_geo.xy);
              float p = niri_clamped_progress;
              if (p * p <= dot(coords, coords))
                  color = vec4(0.0);

              return color * p;
          }

          // This is the function that you must define.
          vec4 open_color(vec3 coords_geo, vec3 size_geo) {
              // You can pick one of the example functions or write your own.
              return default_open(coords_geo, size_geo);
          }
        '';
      window-resize =
        # glsl
        ''
          // Example: fill the current geometry with a solid vertical gradient.
          vec4 solid_gradient(vec3 coords_curr_geo, vec3 size_curr_geo) {
              vec3 coords = coords_curr_geo;
              vec4 color = vec4(0.0);

              // Paint only the area inside the current geometry.
              if (0.0 <= coords.x && coords.x <= 1.0
                      && 0.0 <= coords.y && coords.y <= 1.0)
              {
                  vec4 from = vec4(1.0, 0.0, 0.0, 1.0);
                  vec4 to = vec4(0.0, 1.0, 0.0, 1.0);
                  color = mix(from, to, coords.y);
              }

              return color;
          }

          // Example: crossfade between previous and next texture, stretched to the
          // current geometry.
          vec4 crossfade(vec3 coords_curr_geo, vec3 size_curr_geo) {
              // Convert coordinates into the texture space for sampling.
              vec3 coords_tex_prev = niri_geo_to_tex_prev * coords_curr_geo;
              vec4 color_prev = texture2D(niri_tex_prev, coords_tex_prev.st);

              // Convert coordinates into the texture space for sampling.
              vec3 coords_tex_next = niri_geo_to_tex_next * coords_curr_geo;
              vec4 color_next = texture2D(niri_tex_next, coords_tex_next.st);

              vec4 color = mix(color_prev, color_next, niri_clamped_progress);
              return color;
          }

          // Example: next texture, stretched to the current geometry.
          vec4 stretch_next(vec3 coords_curr_geo, vec3 size_curr_geo) {
              vec3 coords_tex_next = niri_geo_to_tex_next * coords_curr_geo;
              vec4 color = texture2D(niri_tex_next, coords_tex_next.st);
              return color;
          }

          // Example: next texture, stretched to the current geometry if smaller, and
          // cropped if bigger.
          vec4 stretch_or_crop_next(vec3 coords_curr_geo, vec3 size_curr_geo) {
              vec3 coords_next_geo = niri_curr_geo_to_next_geo * coords_curr_geo;

              vec3 coords_stretch = niri_geo_to_tex_next * coords_curr_geo;
              vec3 coords_crop = niri_geo_to_tex_next * coords_next_geo;

              // We can crop if the current window size is smaller than the next window
              // size. One way to tell is by comparing to 1.0 the X and Y scaling
              // coefficients in the current-to-next transformation matrix.
              bool can_crop_by_x = niri_curr_geo_to_next_geo[0][0] <= 1.0;
              bool can_crop_by_y = niri_curr_geo_to_next_geo[1][1] <= 1.0;

              vec3 coords = coords_stretch;
              if (can_crop_by_x)
                  coords.x = coords_crop.x;
              if (can_crop_by_y)
                  coords.y = coords_crop.y;

              vec4 color = texture2D(niri_tex_next, coords.st);

              // However, when we crop, we also want to crop out anything outside the
              // current geometry. This is because the area of the shader is unspecified
              // and usually bigger than the current geometry, so if we don't fill pixels
              // outside with transparency, the texture will leak out.
              //
              // When stretching, this is not an issue because the area outside will
              // correspond to client-side decoration shadows, which are already supposed
              // to be outside.
              if (can_crop_by_x && (coords_curr_geo.x < 0.0 || 1.0 < coords_curr_geo.x))
                  color = vec4(0.0);
              if (can_crop_by_y && (coords_curr_geo.y < 0.0 || 1.0 < coords_curr_geo.y))
                  color = vec4(0.0);

              return color;
          }

          // Example: cropped next texture if it's bigger than the current geometry, and
          // crossfade between previous and next texture otherwise.
          vec4 crossfade_or_crop_next(vec3 coords_curr_geo, vec3 size_curr_geo) {
              vec3 coords_next_geo = niri_curr_geo_to_next_geo * coords_curr_geo;
              vec3 coords_prev_geo = niri_curr_geo_to_prev_geo * coords_curr_geo;

              vec3 coords_crop = niri_geo_to_tex_next * coords_next_geo;
              vec3 coords_stretch = niri_geo_to_tex_next * coords_curr_geo;
              vec3 coords_stretch_prev = niri_geo_to_tex_prev * coords_curr_geo;

              // We can crop if the current window size is smaller than the next window
              // size. One way to tell is by comparing to 1.0 the X and Y scaling
              // coefficients in the current-to-next transformation matrix.
              bool can_crop_by_x = niri_curr_geo_to_next_geo[0][0] <= 1.0;
              bool can_crop_by_y = niri_curr_geo_to_next_geo[1][1] <= 1.0;
              bool crop = can_crop_by_x && can_crop_by_y;

              vec4 color;

              if (crop) {
                  // However, when we crop, we also want to crop out anything outside the
                  // current geometry. This is because the area of the shader is unspecified
                  // and usually bigger than the current geometry, so if we don't fill pixels
                  // outside with transparency, the texture will leak out.
                  //
                  // When crossfading, this is not an issue because the area outside will
                  // correspond to client-side decoration shadows, which are already supposed
                  // to be outside.
                  if (coords_curr_geo.x < 0.0 || 1.0 < coords_curr_geo.x ||
                          coords_curr_geo.y < 0.0 || 1.0 < coords_curr_geo.y) {
                      color = vec4(0.0);
                  } else {
                      color = texture2D(niri_tex_next, coords_crop.st);
                  }
              } else {
                  // If we can't crop, then crossfade.
                  color = texture2D(niri_tex_next, coords_stretch.st);
                  vec4 color_prev = texture2D(niri_tex_prev, coords_stretch_prev.st);
                  color = mix(color_prev, color, niri_clamped_progress);
              }

              return color;
          }

          // This is the function that you must define.
          vec4 resize_color(vec3 coords_curr_geo, vec3 size_curr_geo) {
              // You can pick one of the example functions or write your own.
              return crossfade_or_crop_next(coords_curr_geo, size_curr_geo);
          }
        '';
    };
  };
}
