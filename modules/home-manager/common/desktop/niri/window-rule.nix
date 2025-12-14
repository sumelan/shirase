{lib, ...}: let
  inherit
    (lib.custom.colors)
    gray3
    white3
    orange_bright
    red_bright
    ;
in {
  xdg.configFile."niri/window-rule.kdl".text =
    #kdl
    ''
      window-rule {
          draw-border-with-background false
          geometry-corner-radius 10.000000 10.000000 10.000000 10.000000
          clip-to-geometry true
      }
      window-rule {
          match is-floating=true is-focused=true
          focus-ring { width 2; }
          opacity 0.980000
      }
      window-rule {
          match is-floating=true is-focused=false
          opacity 0.950000
      }
      window-rule {
          match is-floating=false is-focused=true
          focus-ring { width 4; }
          opacity 0.980000
      }
      window-rule {
          match is-floating=false is-focused=false
          opacity 0.900000
      }

      window-rule {
          match is-window-cast-target=true
          focus-ring {
              active-gradient angle=180 from="${orange_bright}" relative-to="window" to="${red_bright}"
              inactive-color "${gray3}"
          }
          shadow {
              on
              offset x=0 y=0
              softness 20
              spread 10
              draw-behind-window false
              color "${white3}90"
          }
          tab-indicator {
              active-color "${red_bright}"
              inactive-color "${gray3}"
          }
      }

      window-rule {
          match app-id="^.blueman-manager-wrapped$"
          open-floating true
      }
      window-rule {
          match app-id="^com.gabm.satty$"
          default-column-width { proportion 0.500000; }
          default-window-height { proportion 0.500000; }
          open-floating true
          opacity 1.000000
      }
      window-rule {
          match app-id="^com.github.johnfactotum.Foliate$"
          block-out-from "screen-capture"
      }
      window-rule {
          match app-id="^com.github.wwmm.easyeffects$"
          default-column-width { proportion 0.500000; }
          default-window-height { proportion 0.500000; }
          open-floating true
      }
      window-rule {
          match app-id="^com.saivert.pwvucontrol$"
          open-floating true
      }
      window-rule {
          match app-id="^mpv$"
          default-column-width { proportion 0.500000; }
          default-window-height { proportion 0.480000; }
          open-floating true
          opacity 1.000000
      }
      window-rule {
          match app-id="^org.gnome.Nautilus$"
          match app-id="^xdg-desktop-portal-gtk$"
          default-column-width { proportion 0.500000; }
          default-window-height { proportion 0.500000; }
          open-floating true
      }
      window-rule {
          match app-id="^org.kde.kdeconnect-indicator$"
          open-floating true
      }
      window-rule {
          match title="^ピクチャーインピクチャー$"
          match title="^ピクチャー イン ピクチャー$"
          match title="^Picture-in-Picture$"
          open-floating true
          opacity 1.000000
      }
      window-rule {
          match app-id="^swayimg$"
          default-column-width { proportion 0.500000; }
          default-window-height { proportion 0.500000; }
          open-floating true
          opacity 1.000000
      }

      window-rule {
          match app-id="^org.gnome.seahorse.Application$"
          block-out-from "screen-capture"
      }
      window-rule {
          match app-id="^Proton Mail$"
          match app-id="^Proton Pass$"
          match app-id="^.protonvpn-app-wrapped$"
          block-out-from "screen-capture"
      }
    '';
}
