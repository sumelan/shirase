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
    ]
    ++ optional config.custom.backlight.enable
    # initial backlight
    {argv = ["brightnessctl" "set" "5%"];};
}
