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
        OnBootSec = "10s";
        OnUnitActiveSec = "12min";
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
              wallMap = nameList: map (x: "${lib.getExe pkgs.waypaper} --random --monitor " + x) nameList;
              nameList =
                [
                  config.lib.monitors.mainMonitorName
                ]
                ++ (lib.optional (config.lib.monitors.otherMonitorsNames != [ ]) (
                  builtins.toString config.lib.monitors.otherMonitorsNames
                ));
            in
            wallMap nameList;
        };
      };
    };
  };

  programs.niri.settings.spawn-at-startup = [
    {
      command = [
        "${lib.getExe pkgs.waypaper}"
        "--restore"
      ];
    }
  ];

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
