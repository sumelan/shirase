{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) singleton;
  inherit (lib.custom.colors) cyan_bright;
  inherit (lib.custom.niri) spawn hotkey;
in {
  home = {
    packages = builtins.attrValues {
      inherit
        (pkgs)
        swww
        waypaper
        ;
    };
    file = {
      ".backdrop.png".source = ./nord-night-aurora.png;
    };
  };

  programs.niri.settings = {
    spawn-at-startup = [
      {
        argv = ["swww-daemon"];
      }
      {
        argv = ["swww-daemon" "--namespace" "backdrop"];
      }
      {
        argv = ["swww" "img" "--namespace" "backdrop" "${config.home.homeDirectory}/.backdrop.png"];
      }
    ];
    binds = {
      "Mod+W" = {
        action.spawn = spawn "waypaper";
        hotkey-overlay.title = hotkey {
          color = cyan_bright;
          name = "  Waypaper";
          text = "Wallpaper Selector";
        };
      };
    };
    window-rules = [
      {
        matches = singleton {
          app-id = "^waypaper$";
        };
        open-floating = true;
        default-column-width.proportion = 0.45;
        default-window-height.proportion = 0.5;
      }
    ];
    layer-rules = [
      {
        matches = singleton {
          namespace = "^swww-daemon$";
        };
        opacity = 0.7;
      }
      {
        matches = singleton {
          namespace = "backdrop";
        };
        place-within-backdrop = true;
        opacity = 1.0;
      }
    ];
  };

  custom.persist = {
    home = {
      directories = [
        ".config/waypaper"
      ];
      cache.directories = [
        ".cache/swww"
        ".cache/waypaper"
      ];
    };
  };
}
