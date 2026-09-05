_: {
  # Animations
  animations = 1;
  animation_type_open = "slide";
  animation_type_close = "slide";
  animation_duration_open = 400;
  animation_duration_close = 800;
  animation_curve = {
    open = "0.46,1.0,0.29,1";
    close = "0.08,0.92,0,1";
  };

  layer_animations = 0;

  # Window effects
  blur = 1;
  blur_layer = 0;
  blur_optimized = 1;
  blur_params = {
    radius = 5;
    num_passes = 2;
    noise = 0.02;
    brightness = 0.9;
    contrast = 0.9;
    saturation = 1.0;
  };

  # Opacity & Corner Radisu
  border_radius = 10;
  no_radius_when_single = 0;
  focused_opacity = 0.88;
  unfocused_opacity = 0.75;

  # Shadows
  shadows = 1;
  shadows_size = 4;
  shadows_blur = 12;
  shadows_position = {
    x = 2;
    y = 2;
  };
  shadowscolor = "0x000000ff";
  shadow_only_floating = 0;
}
