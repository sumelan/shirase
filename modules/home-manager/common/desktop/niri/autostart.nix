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
    # initial backlight
    (mkIf config.custom.backlight.enable {
      argv = ["${pkgs.brightnessctl}/bin/brightnessctl" "set" "5%"];
    })
    # battery-notify
    (mkIf config.custom.battery.enable {
      argv = ["battery-notify"];
    })
  ];
}
