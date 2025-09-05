{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkIf
    getExe
    singleton
    ;
in {
  programs.niri.settings.spawn-at-startup = [
    # network
    {argv = singleton "nm-applet";}
    # bluetooth
    {argv = singleton "blueman-applet";}
    # clipboard manager
    # { sh = "${lib.getExe' pkgs.wl-clipboard "wl-paste"} --watch ${lib.getExe pkgs.cliphist} store"; }
    # initial backlight
    (mkIf config.custom.backlight.enable {
      argv = ["${getExe pkgs.brightnessctl}" "set" "5%"];
    })
  ];
}
