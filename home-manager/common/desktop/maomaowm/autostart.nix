{
  lib,
  pkgs,
  config,
  ...
}:
let
  backlight.sh =
    lib.optionalString config.custom.backlight.enable pkgs.writeShellScript "backlight.sh"
      # bash
      ''
        ${lib.getExe pkgs.brightnessctl} set 5%
      '';
in
{
  wayland.windowManager.maomaowm.autostart_sh =
    # bash
    ''
      set +e
      # obs
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=maomao >/dev/null 2>&1
      ${lib.getExe' pkgs.xdg-desktop-portal-wlr "xdg-desktop-portal-wlr"} >/dev/null 2>&1 &
      # keep clipboard content
      ${lib.getExe pkgs.wl-clip-persist} --clipboard regular --reconnect-tries 0 >/dev/null 2>&1 &
      # clipboard content manager
      ${lib.getExe' pkgs.wl-clipboard "wl-paste"} --watch ${lib.getExe pkgs.cliphist} store >/dev/null 2>&1 &
      # bluetooth 
      blueman-applet >/dev/null 2>&1 &
      # network
      nm-applet >/dev/null 2>&1 &
      # set initial backlight value
      ${backlight.sh}
    '';
}
