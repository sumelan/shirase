{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (config.custom.niri) monitors;
in
{
  import = [
    ./keybinds.nix
  ];

  options.custom = with lib; {
    niri = {
      enable = mkEnableOption "niri" // {
        default = true;
      };
      monitors = {
        name = mkOption {
          type = str;
          description = "The name of the display, e.g. eDP-1";
        };
        background-color = mkOption {
          type = str;
          description = "The background color of this output";
        };
        height = mkOption {
          type = int;
          description = "Pixel width of this output";
        };
        width = mkOption {
          type = int;
          description = "Pixel width of this output";
        };
        refresh = mkOption {
          type = int;
          default = 60;
          description = "Refresh rate of this output";
        };
        x-position = mkOption {
          type = int;
          default = "0";
          description = "X-position of this output";
        };
        y-position = mkOption {
          type = str;
          default = "0";
          description = "Y-position of this output";
        };
        scale = mkOption {
          type = float;
          default = 1.0;
          description = "The scale of this output";
        };
        flipped = mkEnableOption "Whether to flip this output vertically" // {
          default = false;
        };
        rotation = mkOption {
          type = int;
          default = 0;
          description = 
            "Counter-clockwise rotation of this output in degrees. one of [0, 90, 180, 270]";
        };
        vrr = mkOption {
          type = either bool str;
          default = false;
          description = 
            "Whether to enable variable refresh rate (VRR) on this output. one of [false, "on-demand" true]";
        };
      };
    };
  };

  config = lib.mkIf config.custom.niri.enable {
    # start niri-session
    custom.autologinCommand = "${lib.getExe pkgs.niri-stable}/bin/niri-session";

    home.packages = with pkgs; [
      swww
      # clipboard history
      clipman
      wl-clipboard
    ];

    programs.niri = {
      settings = {
        hotkey-overlay.skip-at-startup = true;
        prefer-no-csd = true;
        screenshot-path = "~/Pictures/Screenshots/%Y-%m-%d %H-%M-%S.png";
        cursor.size = 20;

        spawn-at-startup = [
          { command = [ "swww-daemon" ]; }
          { command = [ "swaync" ]; }
          { command = [ "sh" "-c" "eww" "open" "--config" "~/.config/eww/statusbar/" "statusbar" "--arg" "stacking=overlay" ]; }
          { coomand = [ "sh" "-c" "wl-paste" "-t" "text" "--watch" "clipman" "store" "--no-persist" ]; }
        ];

        input = {
          workspace-auto-back-and-forth = true;
          keyboard = {
            xkb.layout = "us";
            xkb.options = "grp:caps_toggle";
          };
          mouse.accel-profile = "flat";
          touchpad = {
            tap = true;
            natural-scroll = true;
            middle-emulation = true;
            scroll-factor = 0.2;
          };
        };

        outputs = {
          "${monitors.name}" = {
            enable = true;
            inherit (monitors) scale;
            inherit (monitors) background-color;
            variable-refresh-rate = monitors.vrr;
            mode = {
              inherit (monitors) height;
              inherit (monitors) width;
              inherit (monitors) refresh;
            };
            position = {
              x = monitors.X-position;
              y = monitors.Y-position;
            };
            transform = {
              inherit (monitors) flipped;
              inherit (monitors) rotation;
            };
          };
        };

        # Environmental Variables
        environment = {
          TERMINAL = "kitty";
          DISPLAY = ":0";
        };

        # Looks & UI
        layout = {
          gaps = 4;
          center-focused-column = "never";
          default-column-width.proportion = 0.5;
          border.enable = false;
          focus-ring = {
            width = 4;
            active.gradient = {
              from = "#7700AE";
              to = "#0060FF";
              angle = 45;
            };
          };
          preset-column-widths = [
            { proportion = 0.25; }
            { proportion = 0.5; }
            { proportion = 0.75; }
            { proportion = 1.0; }
          ];
        };
      };
    };
  };
}
