{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.way-edges.homeManagerModules.default
  ];

  programs = {
    way-edges = {
      enable = true;
      settings = {
        ensure_load_group = [
          "niri"
          "tray"
          "clock"
          "stats"
          "slider"
        ];
        groups = [
          {
            name = "niri";
            widgets =
              (import ./column.nix { inherit lib config; }) ++ (import ./workspace.nix { inherit config; });
          }
          #  {
          #    name = "tray";
          #    widgets = (import ./tray.nix { inherit config; });
          #  }
          #  {
          #    name = "clock";
          #    widgets = (import ./clock.nix { inherit config; });
          #  }
          {
            name = "stats";
            widgets = (import ./stats.nix { inherit lib config; });
          }
          #  {
          #    name = "slider";
          #    widgets = (import ./slider.nix { inherit lib config; });
          #  }
        ];
      };
    };

    niri.settings = {
      binds = with config.lib.niri.actions; {
        "Mod+S" = {
          action = spawn "way-edges" "togglepin" "stats:stats";
          hotkey-overlay.title = "Toggle Stats Widgets";
        };
      };
      layer-rules = [
        {
          matches = [ { namespace = "^(way-edges-widget)$"; } ];
          opacity = config.stylix.opacity.desktop;
        }
      ];
    };
  };
  systemd.user.services = {
    "way-edges" = {
      Install.WantedBy = [ "graphical-session.target" ];
      Unit = {
        Description = "Run way-edges";
        After = [ "graphical-session.target" ];
        Wants = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${lib.getExe' inputs.way-edges.packages."${pkgs.system}".default "way-edges"}";
        Restart = "on-failure";
        ExecStartPre = "${lib.getExe' pkgs.coreutils "sleep"} 1";
        ExecStartPost = "${lib.getExe' pkgs.coreutils "sleep"} 1";
        RestartSec = 3;
      };
    };
  };
}
