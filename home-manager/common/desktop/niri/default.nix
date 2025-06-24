{ lib, config, ... }:
{
  imports = [
    ./animations.nix
    ./autostart.nix
    ./idle.nix
    ./keybinds.nix
    ./lock.nix
    ./monitors.nix
    ./niriswitcher.nix
    ./rules.nix
  ];

  options.custom = with lib; {
    xwayland.enable = mkEnableOption "Enable xwayland-satellite" // {
      default = true;
    };
  };

  config = {
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
        hotkey-overlay.skip-at-startup = true;
        prefer-no-csd = true;

        xwayland-satellite.enable = config.custom.xwayland.enable;

        input = {
          focus-follows-mouse.enable = true;
          touchpad.natural-scroll = true;
          power-key-handling.enable = false; # niri handle power button as sleep by default
        };

        cursor = {
          theme = config.stylix.cursor.name;
          size = config.stylix.cursor.size;
        };

        # apply function f to every element of attrset
        outputs = builtins.mapAttrs (name: value: {
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
                to = base0B;
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
            active.color = base0D;
            inactive.color = base02;
            gap = 5;
            width = 6;
            length.total-proportion = 0.5;
            gaps-between-tabs = 2;
          };
        };

        overview.zoom = 0.7;

        environment = {
          QT_QPA_PLATFORM = "wayland";
          ELECTRON_OZONE_PLATFORM_HINT = "auto";
        };
      };
    stylix.targets.niri.enable = false;
  };
}
