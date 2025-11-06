{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkIf
    singleton
    ;
in {
  programs.niri.settings.spawn-at-startup = [
    # network
    {argv = singleton "nm-applet";}
    # bluetooth
    {argv = singleton "blueman-applet";}
    # initial backlight
    (mkIf config.custom.backlight.enable {
      argv = ["${pkgs.brightnessctl}/bin/brightnessctl" "set" "5%"];
    })
  ];
}
