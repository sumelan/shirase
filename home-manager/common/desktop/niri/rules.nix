{
  lib,
  config,
  ...
}:
lib.mkIf config.custom.niri.enable {
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
      # focused column/window rules
      {
        matches = lib.singleton {
          is-focused = true;
        };
        opacity = config.stylix.opacity.desktop;
      }
      {
        matches = lib.singleton {
          is-focused = false;
        };
        opacity = config.stylix.opacity.desktop * 0.9;
      }
    ];

    switch-events =
      let
        fish = cmd: [
          "fish"
          "-c"
          cmd
        ];
      in
      {
        lid-close.action.spawn = fish "systemctl suspend";
        lid-open.action.spawn = fish "niri msg action power-on-monitors";
      };
  };
}
