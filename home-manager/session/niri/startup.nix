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
          "-s"
          "set"
          "10"
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
