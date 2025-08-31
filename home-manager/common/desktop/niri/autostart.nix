{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
in {
  programs.niri.settings.spawn-at-startup = [
    # network
    {argv = ["nm-applet"];}
    # bluetooth
    {argv = ["blueman-applet"];}
    # clipboard manager
    # { sh = "${lib.getExe' pkgs.wl-clipboard "wl-paste"} --watch ${lib.getExe pkgs.cliphist} store"; }
    # initial backlight
    (mkIf config.custom.backlight.enable {
      argv = ["${lib.getExe pkgs.brightnessctl}" "set" "5%"];
    })
  ];
}
