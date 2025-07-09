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
  wayland.windowManager.maomaowm.autostart_sh =
    lib.mkIf config.custom.maomaowm.enable
      # bash
      ''
        set +e

        dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots
        ${lib.getExe' pkgs.xdg-desktop-portal-wlr "xdg-desktop-portal-wlr"} &

        ${lib.getExe pkgs.wl-clip-persist} ----clipboard regular --reconnect-tries 0 &
        ${lib.getExe' pkgs.wl-clipboard "wl-paste"} --watch ${lib.getExe pkgs.cliphist} store &

        killall .nm-applet-wrap
        killall .blueman-applet
        nm-applet &
        blueman-applet &
        ${adjustBacklight}
      '';
}
