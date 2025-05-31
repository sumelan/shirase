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
        open-on-output = builtins.toString config.lib.monitors.otherMonitorsNames;
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
        opacity = config.stylix.opacity.desktop;
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
        opacity = config.stylix.opacity.desktop * 0.9;
      }
    ];

    layer-rules = [
      {
        matches = [ { namespace = "^(waybar)$"; } ];
        opacity = config.stylix.opacity.desktop;
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
