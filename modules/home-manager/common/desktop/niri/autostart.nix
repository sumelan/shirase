{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
in {
  programs.niri.settings.spawn-at-startup = [
    # network
    {argv = ["nm-applet"];}
    # bluetooth
    {argv = ["blueman-applet"];}
    (
      mkIf config.custom.backlight.enable
      # initial backlight
      {argv = ["brightnessctl" "set" "5%"];}
    )
    (
      mkIf config.custom.battery.enable
      # battery-notify
      {argv = ["battery-notify"];}
    )
  ];
}
