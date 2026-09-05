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
