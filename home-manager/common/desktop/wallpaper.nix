{
  lib,
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    swww
    waypaper
  ];

  systemd.user = {
    timers."waypaper" = {
      Install.WantedBy = [ "timers.target" ];
      Unit = {
        Description = "Set a random wallpaper every 12 minutes";
      };
      Timer = {
        Persistent = true;
        OnCalendar = "*:00/12";
      };
    };

    services = {
      "waypaper" = {
        Install.WantedBy = [ "graphical-session.target" ];
        Unit = {
          Description = "Set a random wallpaper with waypaper";
          After = [ "graphical-session.target" ];
          PartOf = [ "graphical-session.target" ];
        };
        Service = {
          Type = "oneshot";
          ExecStart =
            let
              wallCommand = map (x: "${lib.getExe' pkgs.waypaper "waypaper"} --random --monitor " + x) [
                config.lib.monitors.mainMonitorName
                (builtins.toString config.lib.monitors.otherMonitorsNames)
              ];
            in
            wallCommand;
          # possible race condition, introduce a small delay before starting
          # https://github.com/LGFae/swww/issues/317#issuecomment-2131282832
          ExecStartPre = "${lib.getExe' pkgs.coreutils "sleep"} 1";
        };
      };
    };
  };

  custom.persist = {
    home = {
      directories = [
        ".config/waypaper"
      ];
      cache.directories = [
        ".cache/waypaper"
      ];
    };
  };
}
