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
          (import ./workspace.nix { inherit config; })
          ++ (import ./stats.nix { inherit config isLaptop; })
          ++ (import ./infotext.nix {
            inherit
              lib
              config
              pkgs
              isLaptop
              ;
          })
          ++ (import ./progress.nix { inherit lib config pkgs; })
        #  ++ (import ./tray.nix { inherit config; })
        ;
      };
    };

    niri.settings = {
      binds =
        let
          toggleWidget = map (x: "way-edges togglepin " + x) [
            "workspace"
            "info"
            "progress"
            "stats"
          ];
          cmd = lib.concatStringsSep "; " (
            [ "niri msg action toggle-overview" ]
            ++ [ "${lib.getExe pkgs.killall} -SIGUSR1 .waybar-wrapped" ]
            ++ toggleWidget
          );
        in
        {
          "Mod+Tab" = config.niri-lib.run {
            inherit cmd;
            title = "Open the Overview and Widgets";
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
        Description = "way-edges";
        After = [ "graphical-session.target" ];
        Wants = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${lib.getExe inputs.way-edges.packages."${pkgs.system}".default}";
        Restart = "always";
        RestartSec = 1;
      };
    };
  };
}
