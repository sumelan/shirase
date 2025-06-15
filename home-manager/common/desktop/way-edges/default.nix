{
  lib,
  config,
  pkgs,
  inputs,
  isLaptop,
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
        widgets =
          (import ./column.nix { inherit config; })
          ++ (import ./workspace.nix { inherit config; })
          ++ (import ./stats.nix { inherit config isLaptop; })
        #   ++ (import ./tray.nix { inherit config; })
        #   ++ (import ./clock.nix { inherit config; })
        #   ++ (import ./slider.nix { inherit lib config; })
        ;
      };
    };

    niri.settings = {
      binds = with config.lib.niri.actions; {
        "Mod+C" = {
          action = spawn "way-edges" "togglepin" "move-column";
          hotkey-overlay.title = "Toggle Column Widgets";
        };
        "Mod+S" = {
          action = spawn "way-edges" "togglepin" "stats";
          hotkey-overlay.title = "Toggle Stats Widgets";
        };
      };
      layer-rules = [
        {
          # match namespace contains 'way-edges-widget'
          matches = [ { namespace = "way-edges-widget"; } ];
          opacity = config.stylix.opacity.desktop * 0.9;
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
        ExecStart = "${lib.getExe inputs.way-edges.packages."${pkgs.system}".default}";
        Restart = "on-failure";
        ExecStartPre = "${lib.getExe' pkgs.coreutils "sleep"} 1";
        ExecStartPost = "${lib.getExe' pkgs.coreutils "sleep"} 1";
        RestartSec = 1;
      };
    };
  };
}
