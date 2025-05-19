{ lib, pkgs, ... }:
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
        command = [ "nm-applet" ];
      }
      {
        command = [
          "fcitx5"
          "-d"
          "-r"
        ];
      }
      {
        command = [ "${lib.getExe' pkgs.xwayland-satellite "xwayland-satellite"}" ];
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
    ];
  };

  systemd.user.services = {
    "polkit-gnome-authentication-agent-1" = {
      Install.WantedBy = [ "graphical-session.target" ];
      Unit = {
        Description = "polkit-gnome-authentication-agent-1";
        Wants = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
