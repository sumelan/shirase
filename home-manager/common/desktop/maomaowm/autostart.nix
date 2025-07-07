{
  lib,
  pkgs,
  config,
  ...
}:
let
  adjustBacklight = lib.optionalString config.custom.backlight.enable ''
    ${lib.getExe pkgs.brightnessctl} set 5%
  '';
in
{
  wayland.windowManager.maomaowm.autostart_sh = lib.mkIf config.custom.maomaowm.enable ''
    swww kill
    swww-daemon --namespace background &
    killall .nm-applet-wrap
    killall .blueman-applet
    nm-applet &
    blueman-applet &
    ${lib.getExe' pkgs.wl-clipboard "wl-paste"} --watch ${lib.getExe pkgs.cliphist} store &
    ${adjustBacklight}
  '';
}
