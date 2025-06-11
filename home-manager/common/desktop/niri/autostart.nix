{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.custom = with lib; {
    xwayland.enable = mkEnableOption "Enable xwayland";
  };

  config = {
    programs.niri.settings.spawn-at-startup = [
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
        command = [
          "${lib.getExe pkgs.brightnessctl}"
          "set"
          "5%"
        ];
      }
      {
        command = [
          "${lib.getExe' pkgs.wl-clipboard "wl-paste"}"
          "--watch"
          "${lib.getExe pkgs.cliphist}"
          "store"
        ];
      }
      (lib.mkIf config.custom.xwayland.enable {
        command = [ "${lib.getExe pkgs.xwayland-satellite}" ];
      })
    ];

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
  };
}
