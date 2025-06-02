{
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.way-edges.homeManagerModules.default
  ];

  programs = {
    way-edges = with config.lib.stylix.colors.withHashtag; {
      enable = true;
      settings = {
        ensure_load_group = [
          "niri"
        ];
        groups =
          let
            left-click = 272;
            right-click = 273;
            middle-click = 274;
            side-click-1 = 275;
            side-click-2 = 276;

            columnTransition = direction: color: {
              name = "focus-column-${direction}";
              edge = "top";
              position = "${direction}";
              layer = "overlay";
              monitor = config.lib.monitors.mainMonitorName;
              extra_trigger_size = 0;
              preview_size = "15%";
              animation_curve = "ease-expo";
              transition_duration = 300;
              margins.${direction} = "18%";
              ignore_exclusive = false;
              pinnable = true;
              pin-with-key = true;
              pin_key = right-click;
              widget = {
                type = "btn";
                thickness = 15;
                length = "20%";
                color = "${color}";
                border_width = 2;
                border_color = "${base09}";
                event_map = {
                  ${builtins.toString left-click} = "niri msg action focus-column-${direction}";
                };
              };
            };
          in
          [
            {
              name = "niri";
              widgets = [ (columnTransition "left" "${base0E}") ] ++ [ (columnTransition "right" "${base0D}") ];
            }
          ];
      };
    };

    niri.settings = {
      layer-rules = [
        {
          matches = [ { namespace = "^(way-edges-widget)$"; } ];
          opacity = config.stylix.opacity.desktop;
        }
      ];
      spawn-at-startup = [
        {
          command = [ "way-edges" ];
        }
      ];
    };
  };
}
