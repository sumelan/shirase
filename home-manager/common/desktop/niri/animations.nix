_: {
  programs.niri.settings.animations = {
    enable = true;
    # Slow down all animations by this factor. Values below 1 speed them up instead.
    slowdown = 1.0;
    window-open = {
      kind.spring = {
        damping-ratio = 0.7;
        stiffness = 300;
        epsilon = 0.001;
      };
      custom-shader =
        # glsl
        ''
          vec4 close_color(vec3 coords_geo, vec3 size_geo) {
              float p = niri_clamped_progress;

              float vertical_shrink = smoothstep(0.0, 0.5, p);
              float horizontal_shrink = smoothstep(0.5, 0.8, p);

              vec2 scale = max(vec2(1.0 - horizontal_shrink, 1.0 - vertical_shrink), 0.0015);

              float aspect_ratio = size_geo.x / size_geo.y;
              vec2 centered_coords = coords_geo.xy - 0.5;
              centered_coords.x *= aspect_ratio;

              vec2 scaled_coords = centered_coords / scale;

              vec4 color = vec4(0.0);

              float glow_width = 0.02;
              float glow_strength = 0.2;
              vec3 glow_color = vec3(1.0, 1.0, 1.0);

              float border_radius = 0.01;

              vec2 box_half_size = vec2(0.5 * aspect_ratio, 0.5);

              vec2 dist = abs(scaled_coords) - (box_half_size - border_radius);
              float glow_dist = length(max(dist, 0.0)) - border_radius;

              float glow_intensity = smoothstep(glow_width, 0.0, glow_dist);

              color.rgb += glow_color * glow_intensity * (1.0 - horizontal_shrink) * glow_strength;

              if (abs(scaled_coords.x) <= box_half_size.x && abs(scaled_coords.y) <= box_half_size.y) {

                  vec2 texture_uv = scaled_coords / vec2(aspect_ratio, 1.0);

                  vec3 sample_coords_geo = vec3(texture_uv + 0.5, 1.0);
                  vec3 coords_tex = niri_geo_to_tex * sample_coords_geo;
                  color = texture2D(niri_tex, coords_tex.st);

                  float flash_intensity = 0.4 / (1.0 - p);
                  color.rgb += flash_intensity;
              }

              if (p > 0.5) {
                  float collapse_progress = (vertical_shrink + horizontal_shrink);

                  float glow = pow(1.0 - length(centered_coords), 200.0) * collapse_progress * 3.0;
                  color.rgb += glow;
              }

              color *= (1.0 - smoothstep(0.8, 1.0, p));

              return color;
          }
        '';
    };
    window-close = {
      kind.easing = {
        curve = "ease-out-quad";
        duration-ms = 1000;
      };
      custom-shader =
        # glsl
        ''
          // old TV shut down effect
          vec4 close_color(vec3 coords_geo, vec3 size_geo) {
          float p = niri_clamped_progress;

          float vertical_shrink = smoothstep(0.0, 0.5, p);
          float horizontal_shrink = smoothstep(0.5, 0.8, p);

          // change the 0.0015 to a larger value if you want the bar to be thicker
          vec2 scale = max(vec2(1.0 - horizontal_shrink, 1.0 - vertical_shrink), 0.0015);

          vec2 centered_coords = coords_geo.xy - 0.5;
          vec2 scaled_coords = centered_coords / scale;

          vec4 color = vec4(0.0);

          // this will only affect the area inside the scale
          if (abs(scaled_coords.x) <= 0.5 && abs(scaled_coords.y) <= 0.5) {
              vec3 sample_coords_geo = vec3(scaled_coords + 0.5, 1.0);
              vec3 coords_tex = niri_geo_to_tex * sample_coords_geo;
              color = texture2D(niri_tex, coords_tex.st);

              float flash_intensity = 0.4 / (1.0 - p);
              color.rgb += flash_intensity;
          }

          // this is the glowing dot in the middle!!
          if (p > 0.5) {
            float collapse_progress = (vertical_shrink + horizontal_shrink);
            float glow = pow(1.0 - length(centered_coords), 200.0) * collapse_progress * 3.0;
            color.rgb += glow;
          }

          // fade out at the end
          color *= (1.0 - smoothstep(0.8, 1.0, p));

          return color;
          }
        '';
    };
    window-resize = {
      custom-shader =
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
