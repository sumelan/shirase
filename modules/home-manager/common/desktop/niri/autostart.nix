{
  lib,
  config,
  ...
}: let
  inherit (lib) optional;
in {
  programs.niri.settings.spawn-at-startup =
    [
      # network
      {argv = ["nm-applet"];}
      # bluetooth
      {argv = ["blueman-applet"];}
      # clipboard
      {argv = ["wl-paste" "--watch" "cliphist" "store"];}
    ]
    ++ optional config.custom.backlight.enable
    # initial backlight
    {argv = ["brightnessctl" "set" "5%"];};
}
