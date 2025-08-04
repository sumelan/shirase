{
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./animations.nix
    ./autostart.nix
    ./keybinds.nix
    ./niriswitcher.nix
    ./rules.nix
  ];

  options.custom = {
    niri = {
      enable = lib.mkEnableOption "Enablen niri" // {
        default = true;
      };
      xwayland.enable = lib.mkEnableOption "Enable xwayland-satellite";
    };
  };

  config = lib.mkIf config.custom.niri.enable {
    programs.niri.settings =
      with config.lib.stylix.colors.withHashtag;
      let
        shadowConfig = {
          enable = true;
          spread = 0;
          softness = 10;
          color = "#000000dd";
        };
      in
      {
        hotkey-overlay = {
          skip-at-startup = true;
          hide-not-bound = true;
        };

        prefer-no-csd = true;

        xwayland-satellite = lib.mkIf config.custom.niri.xwayland.enable {
          enable = true;
          path = lib.getExe pkgs.xwayland-satellite;
        };

        input = {
          focus-follows-mouse.enable = true;
          touchpad.natural-scroll = true;
          power-key-handling.enable = false; # niri handle power button as sleep by default
        };

        cursor = {
          theme = config.stylix.cursor.name;
          inherit (config.stylix.cursor) size;
        };

        # apply function f to every element of attrset
        outputs = builtins.mapAttrs (_name: value: {
          inherit (value) scale mode position;
          transform.rotation = value.rotation;
        }) config.monitors;

        gestures = {
          dnd-edge-view-scroll = {
            trigger-width = 60;
            delay-ms = 100;
            max-speed = 1500;
          };
        };

        layout = {
          gaps = 12;
          background-color = "transparent";
          border = {
            enable = true;
            width = 3;
            active = {
              gradient = {
                from = base0C;
                to = base0D;
                angle = 45;
                in' = "oklab";
              };
            };
            inactive.color = base02;
          };

          focus-ring.enable = false;

          struts = {
            left = 2;
            right = 2;
            top = 0;
            bottom = 2;
          };

          insert-hint = {
            enable = true;
            display = {
              gradient = {
                from = base0D;
                to = base0B;
                angle = 45;
              };
            };
          };

          shadow = shadowConfig;

          tab-indicator = {
            enable = true;
            position = "left";
            hide-when-single-tab = true;
            place-within-column = true;
            active.color = base0B;
            inactive.color = base02;
            gap = 5;
            width = 6;
            length.total-proportion = 0.5;
            gaps-between-tabs = 2;
          };
        };

        environment = {
          DISPLAY = lib.mkIf config.custom.niri.xwayland.enable ":0";
          QT_QPA_PLATFORM = "wayland";
          ELECTRON_OZONE_PLATFORM_HINT = "auto";
        };
      };
    stylix.targets.niri.enable = false;
  };
}
