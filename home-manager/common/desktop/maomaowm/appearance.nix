{ config, ... }:
with config.lib.stylix.colors;
# == define colors ==
''
  rootcolor=0x${base00}ff
  bordercolor=0x${base02}ff
  focuscolor=0x${base0E}ff
  maxmizescreencolor=0x${base0C}ff
  urgentcolor=0x${base08}ff
  scratchpadcolor=0x${base0A}ff
  globalcolor=0x${base0D}ff
''
# == Appearance ==
+ ''
  gappih=5
  gappiv=5
  gappoh=10
  gappov=10
  borderpx=4

  # layout circle limit
  # if not set, it will circle all layout
  # circle_layout=spiral,scroller
''
# == cursor ==
+ ''
  cursor_theme=${config.stylix.cursor.name}
  cursor_size=${config.stylix.cursor.size |> builtins.toString}
''
# == Window Effects ==
+ ''
  blur=1
  blur_optimized=0
  blur_params_radius=10

  shadows=1
  shadows_size=5
  shadows_position_x=0
  shadows_position_y=0

  border_radius=10

  focused_opacity=0.95
  unfocused_opacity=0.8
''
# == Animation Configuration ==
+ ''
  animations=1
  layer_animations=1
  animation_type_open=zoom
  animation_type_close=slide
  animation_fade_in=1
  zoom_initial_ratio=0.5
  fadein_begin_opacity=0.5
  fadeout_begin_opacity=0.8
  animation_duration_move=500
  animation_duration_open=400
  animation_duration_tag=350
  animation_duration_close=800
  animation_curve_open=0.46,1.0,0.29,1
  animation_curve_move=0.46,1.0,0.29,1
  animation_curve_tag=0.46,1.0,0.29,1
  animation_curve_close=0.08,0.92,0,1
  tag_animation_direction=0
''
