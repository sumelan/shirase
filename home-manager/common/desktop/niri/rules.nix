{
  lib,
  config,
  ...
}:
let
  shadowConfig = {
    enable = true;
    spread = 0;
    softness = 10;
    color = "#000000dd";
  };
in
{
  programs.niri.settings = with config.lib.stylix.colors.withHashtag; {
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
      # focused column/window opacity
      {
        matches = lib.singleton {
          is-focused = true;
        };
        opacity = config.stylix.opacity.desktop;
      }
      # out-focued column/window opacity
      {
        matches = lib.singleton {
          is-focused = false;
        };
        opacity = config.stylix.opacity.desktop * 0.9;
      }
      # targeted column/window from screencast program, like obs
      {
        matches = lib.singleton {
          is-window-cast-target = true;
        };
        border = {
          active.color = base08;
          inactive.color = base0A;
        };
        tab-indicator = {
          active.color = base09;
          inactive.color = base0F;
        };
        shadow = shadowConfig;
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
