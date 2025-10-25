{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  options.custom = {
    astal-shell.enable = mkEnableOption "astal-shell";
  };

  config = mkIf config.custom.astal-shell.enable {
    home.packages = builtins.attrValues {
      inherit
        (pkgs)
        gnome-calendar
        gnome-weather
        wf-recorder
        ;
    };

    services = {
      astal-shell = {
        enable = true;
        package = inputs.astal-shell.packages.${pkgs.system}.default;

        # Configure display margins
        displays = {
          "LG HDR 4K" = [390 145];
          "Unknown" = [215 85];
        };

        # Configure theme
        theme = {
          colors = {
            background = {
              primary = "rgba(0, 0, 0, 0.8)";
              secondary = "rgba(0, 0, 0, 0.6)";
            };
            text = {
              primary = "rgba(255, 255, 255, 1.0)";
              secondary = "rgba(255, 255, 255, 0.8)";
              focused = "rgba(255, 255, 255, 1.0)";
              unfocused = "rgba(255, 255, 255, 0.6)";
            };
            accent = {
              primary = "rgba(100, 149, 237, 0.8)";
              secondary = "rgba(100, 149, 237, 0.6)";
              border = "rgba(100, 149, 237, 0.4)";
              overlay = "rgba(100, 149, 237, 0.2)";
            };
            status = {
              success = "rgba(76, 175, 80, 0.8)";
              warning = "rgba(255, 193, 7, 0.8)";
              error = "rgba(244, 67, 54, 0.8)";
            };
          };
          opacity = {
            high = 1.0;
            medium = 0.8;
            low = 0.6;
          };
          font = {
            sizes = {
              small = "0.8em";
              normal = "1em";
              large = "1.2em";
            };
            weights = {
              normal = "normal";
              bold = "bold";
            };
          };
          spacing = {
            small = "4px";
            medium = "8px";
            large = "16px";
          };
          borderRadius = {
            small = "2px";
            medium = "4px";
            large = "9999px";
          };
        };
      };
    };

    programs.niri.settings = {
      binds = {
        "XF86AudioRaiseVolume" = {
          action.spawn = ["volume-control" "up"];
        };
        "XF86AudioLowerVolume" = {
          action.spawn = ["volume-control" "down"];
        };
        "XF86AudioMute" = {
          action.spawn = ["volume-control" "mute"];
        };
        "XF86AudioNext" = {
          action.spawn = ["media-control" "next"];
        };
        "XF86AudioPlay" = {
          action.spawn = ["media-control" "play-pause"];
        };
        "XF86AudioPrev" = {
          action.spawn = ["media-control" "previous"];
        };
        "XF86AudioStop" = {
          action.spawn = ["media-control" "stop"];
        };
        "XF86MonBrightnessUp" = {
          action.spawn = ["brightness-control" "up"];
        };
        "XF86MonBrightnessDown" = {
          action.spawn = ["brightness-control" "down"];
        };
      };
      window-rules = [
        {
          matches = [
            {app-id = "^(org.gnome.Calendar)$";}
            {app-id = "^(org.gnome.Weather)$";}
          ];
          open-floating = true;
        }
      ];
    };

    custom.persist = {
      home.cache.directories = [
        ".cache/astal"
      ];
    };
  };
}
