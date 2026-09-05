{lib, ...}: let
  inherit
    (lib)
    mapAttrsToList
    concatStringsSep
    singleton
    ;
in {
  # monitor
  monitorrule = let
    monitor = {
      name, # ",make:foo,model:bar"
      width,
      height,
      refresh,
      x ? 0,
      y ? 0,
      scale ? 1.0,
      hdr ? 0, # or 1
      rr ? 0, # Monitor transform; 0-7
    }:
      {
        inherit name;
        width = toString width;
        height = toString height;
        refresh = toString refresh;
        x = toString x;
        y = toString y;
        scale = toString scale;
        hdr = toString hdr;
        rr = toString rr;
      }
      |> mapAttrsToList (k: v: k + ":" + v)
      |> concatStringsSep ","
      |> singleton;
  in
    monitor {
      name = ",make:LG Electronics,model:LG HDR 4K";
      width = 3840;
      height = 2160;
      refresh = 60.000000;
      scale = 1.5;
      hdr = 0;
    }
    ++ monitor {
      name = "^DSI-1$";
      width = 1200;
      height = 1920;
      refresh = 90.000000;
      rr = 3;
    };

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
  no_radius_when_single = 1;
  focused_opacity = 0.88;
  unfocused_opacity = 0.75;

  # Animations - use underscores for multi-part keys
  animations = 1;
  animation_type_open = "slide";
  animation_type_close = "slide";
  animation_duration_open = 400;
  animation_duration_close = 800;
  # Or use nested attrs (will be flattened with underscores)
  animation_curve = {
    open = "0.46,1.0,0.29,1";
    close = "0.08,0.92,0,1";
  };

  layer = {
    animations = 0;
  };

  shadows = 1;
  shadows_size = 4;
  shadows_blur = 12;
  shadows_position = {
    x = 2;
    y = 2;
  };
  shadowscolor = "0x000000ff";
  shadow_only_floating = 0;

  cursor_theme = "Capitaine Cursors (Palenight)";
  cursor_size = 38;

  # focus & input
  drag_tile_to_tile = 1;
  trackpad_natural_scrolling = 1;

  # system
  xwayland_persistence = 0;

  tagrule = [
    "id:1,layout_name:tile"
    "id:2,layout_name:scroller"
  ];
}
