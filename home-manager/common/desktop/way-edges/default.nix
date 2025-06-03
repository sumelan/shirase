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
            widgets = (import ./column.nix { inherit config; }) ++ (import ./workspace.nix { inherit config; });
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
      layer-rules = [
        {
          matches = [ { namespace = "^(way-edges-widget)$"; } ];
          opacity = config.stylix.opacity.desktop;
        }
      ];
      spawn-at-startup = [
        {
          command = [ "way-edges" ];
        }
      ];
    };
  };
}
