{
  lib,
  config,
  ...
}:
lib.mkIf config.custom.niri.enable {
  programs.niri.settings = {
    window-rules = [
      {
        # common rules
        geometry-corner-radius = let
          radius = 14.0;
        in
        {
          bottom-left = radius;
          bottom-right = radius;
          top-left = radius;
          top-right = radius;
        };
        clip-to-geometry = true;
        draw-border-with-background = false;
      }

      {
        # floating apps
        matches = [
          { app-id = "^(com.saivert.pwvucontrol)$"; }
          { app-id = "^(dialog)$"; }
          { app-id = "^(file_progress)$"; }
          { app-id = "^(confirm)$"; }
          { app-id = "^(download)$"; }
          { app-id = "^(error)$"; }
          { app-id = "^(notification)$"; }
        ];
        open-floating = true;
      }
    ];

    switch-events = {
      lid-close.action.spawn =
        [ "niri"  "msg" "action"  "power-off-monitors"  ];
      lid-open.action.spawn =
        [ "niri"  "msg" "action"  "power-on-monitors" ];
    };
  };
}
