{ pkgs, ... }:
{
  programs.niri.settings = {
    spawn-at-startup = [
      {
        command = [
          "dbus-update-activation-environment"
          "--all"
          "--systemd"
        ];
      }
      {
        command = [
          "nm-applet"
        ];
      }
      {
        command = [
          "blueman-applet"
        ];
      }
      {
        command = [
          "fcitx5"
          "-d"
        ];
      }
      {
        command = [
          "swww-daemon"
        ];
      }
      {
        command = [
          "brightnessctl"
          "set"
          "5%"
        ];
      }
      {
        command = [
          "wl-paste"
          "--watch"
          "cliphist"
          "store"
        ];
      }
      {
        command = [
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        ];
      }
    ];
  };
}
