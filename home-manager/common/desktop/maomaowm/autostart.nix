{
  lib,
  pkgs,
  config,
  ...
}:
let
  dimBacklight = lib.optionalString config.custom.backlight.enable ''
    ${lib.getExe pkgs.brightnessctl} set 5%
  '';
in
{
  wayland.windowManager.maomaowm.autostart_sh =
    # bash
    ''
      set +e

      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots >/dev/null 2>&1
      ${lib.getExe' pkgs.xdg-desktop-portal-wlr "xdg-desktop-portal-wlr"} >/dev/null 2>&1 &

      ${lib.getExe pkgs.wl-clip-persist} ----clipboard regular --reconnect-tries 0 >/dev/null 2>&1 &
      ${lib.getExe' pkgs.wl-clipboard "wl-paste"} --watch ${lib.getExe pkgs.cliphist} store >/dev/null 2>&1 &

      blueman-applet >/dev/null 2>&1 &

      nm-applet >/dev/null 2>&1 &

      ${dimBacklight}
    '';
}
