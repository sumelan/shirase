_:{
  programs.niri.settings = {
    window-rules = [
      {
        # global rules
        geometry-corner-radius = {
          bottom-left = 10.0;
          bottom-right = 10.0;
          top-left = 10.0;
          top-right = 10.0;
        };
        clip-to-geometry = true;
        draw-border-with-background = false;
      }
      {
        matches = [
          { is-focused = true; }
        ];
        opacity = 0.95;
      }
      {
        matches = [
          { is-focused = false; }
        ];
        opacity = 0.85;
      }
    ];

    switch-events = {
      lid-close.action.spawn =
        [ "niri"  "msg" "action"  "power-off-monitors" ];
      lid-open.action.spawn =
        [ "niri"  "msg" "action"  "power-on-monitors" ];
    };
  };
}
