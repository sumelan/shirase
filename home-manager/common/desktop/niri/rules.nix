{
  lib,
  config,
  isLaptop,
  ...
}:
{
  programs.niri.settings = {
    workspaces = lib.mkIf (!isLaptop) {
      "01-huion" = {
        name = "huion";
        open-on-output = "DP-1";
      };
    };

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
        matches = [ { is-focused = true; } ];
        excludes = lib.mkIf config.custom.krita.enable [
          {
            app-id = "^(krita)$";
          }
          {
            app-id = "^(org.inkscape.Inkscape)$";
          }
        ];
        opacity = 0.95;
      }
      {
        matches = [ { is-focused = false; } ];
        excludes = lib.mkIf config.custom.krita.enable [
          {
            app-id = "^(krita)$";
          }
          {
            app-id = "^(org.inkscape.Inkscape)$";
          }
        ];
        opacity = 0.85;
      }
    ];

    switch-events = {
      lid-close.action.spawn = [
        "niri"
        "msg"
        "action"
        "power-off-monitors"
      ];
      lid-open.action.spawn = [
        "niri"
        "msg"
        "action"
        "power-on-monitors"
      ];
    };
  };
}
