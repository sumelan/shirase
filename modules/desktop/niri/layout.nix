{config, ...}: let
  inherit
    (config.flake.lib.colors)
    black0
    gray3
    blue0
    cyan_bright
    green_dim
    green_bright
    ;
in {
  flake.modules.homeManager.default = _: {
    xdg.configFile."niri/layout.kdl".text =
      # kdl
      ''
        layout {
            gaps 14
            center-focused-column "never"
            always-center-single-column
            empty-workspace-above-first
            default-column-display "tabbed"
            background-color "transparent"

            preset-column-widths {
                proportion 0.33333
                proportion 0.5
                proportion 0.66667
            }

            default-column-width { proportion 0.5; }

            preset-window-heights {
                proportion 0.33333
                proportion 0.5
                proportion 0.66667
            }

            focus-ring {
                width 4
                active-gradient angle=180 from="${green_bright}" relative-to="window" to="${cyan_bright}"
                inactive-color "${gray3}"
            }

            border { off; }

            shadow {
                on
                offset x=0 y=0
                softness 20
                spread 10
                draw-behind-window false
                color "${black0}90"
            }

            tab-indicator {
                hide-when-single-tab
                place-within-column
                gap -15
                width 8
                length total-proportion=0.800000
                position "bottom"
                gaps-between-tabs 0.000000
                corner-radius 0.000000
                active-color "${blue0}90"
                inactive-color "${gray3}90"
            }

            insert-hint { gradient angle=45 from="${green_dim}" relative-to="window" to="${green_bright}"; }

            struts {
                left 2
                right 2
                top 2
                bottom 2
            }
        }
      '';
  };
}
