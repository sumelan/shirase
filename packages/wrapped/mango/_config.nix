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

  # Focus & input
  drag_tile_to_tile = 1; # Allow dragging a tiled window onto another to swap their positions.
  trackpad_natural_scrolling = 1;

  # Layout
  circle_layout = ["dwindle" "scroller" "vertical_scroller"] |> concatStringsSep ",";
  scroller = {
    default = {
      proportion = 0.5;
      proportion_single = 1.0;
    };
    ignore_proportion_single = 0;
  };

  # Special workspace (Tag 0)
  special = {
    dim = 0.5; # Background dim level when special workspace is active (0.0 to 1.0, default 0.5)
    # Inner and outer gaps for windows on the special workspace
    gappih = 10;
    gappiv = 10;
    gappoh = 280;
    gappov = 120;
  };

  # system
  xwayland_persistence = 0;
}
