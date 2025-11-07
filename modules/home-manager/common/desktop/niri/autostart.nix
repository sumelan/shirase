{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  soundPath = "${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo";
in {
  programs.niri.settings.spawn-at-startup = [
    # network
    {argv = ["nm-applet"];}
    # bluetooth
    {argv = ["blueman-applet"];}
    # initial backlight
    (mkIf config.custom.backlight.enable {
      argv = ["brightnessctl" "set" "5%"];
    })
    # battery-notify
    (mkIf config.custom.battery.enable {
      argv = ["battery-notify"];
    })
    # play sound
    {argv = ["pw-play" "${soundPath}/service-login.oga"];}
  ];
}
