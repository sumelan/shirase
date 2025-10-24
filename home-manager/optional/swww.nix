{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    getExe'
    singleton
    ;
in {
  options.custom = {
    swww.enable = mkEnableOption "swww";
  };

  config = mkIf config.custom.swww.enable {
    home.packages = [pkgs.swww];

    systemd.user.services = {
      "swww-backgroud" = {
        Unit = {
          After = ["graphical-session.target"];
          ConditionEnvironment = "WAYLAND_DISPLAY";
          Description = "Run swww-daemon on backgroud";
          PartOf = ["graphical-session.target"];
        };
        Service = {
          ExecStart = [
            "${getExe' pkgs.swww "swww-daemon"} --namespace _backgroud"
          ];
          Restart = "always";
          RestartSec = "10";
        };
        Install = {
          WantedBy = ["graphical-session.target"];
        };
      };

      "swww-backdrop" = {
        Unit = {
          After = ["graphical-session.target"];
          ConditionEnvironment = "WAYLAND_DISPLAY";
          Description = "Run swww-daemon on backdrop";
          PartOf = ["graphical-session.target"];
        };
        Service = {
          ExecStart = [
            "${getExe' pkgs.swww "swww-daemon"} --namespace _backdrop"
          ];
          Restart = "always";
          RestartSec = "10";
        };
        Install = {
          WantedBy = ["graphical-session.target"];
        };
      };
    };

    programs.niri.settings.layer-rules = [
      {
        matches = singleton {
          namespace = "backdrop";
        };
        place-within-backdrop = true;
      }
    ];

    custom.persist = {
      home.cache.directories = [
        ".cache/swww"
      ];
    };
  };
}
