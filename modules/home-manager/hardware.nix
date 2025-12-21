{
  lib,
  config,
  isLaptop,
  ...
}: let
  inherit (lib) mkOption mkEnableOption;
  inherit
    (lib.types)
    submodule
    bool
    float
    attrsOf
    int
    ;

  monitor = submodule {
    options = {
      isMain = mkOption {
        type = bool;
        description = "Whether the monitor is the main one";
        default = false;
      };
      scale = mkOption {
        type = float;
        description = "The scale of the monitor";
        default = 1.0;
      };
      mode = mkOption {
        type = submodule {
          options = {
            width = mkOption {
              type = int;
              description = "The width of the monitor";
            };
            height = mkOption {
              type = int;
              description = "The height of the monitor";
            };
            refresh = mkOption {
              type = float;
              description = "The refresh rate of the monitor";
            };
          };
        };
      };
      position = mkOption {
        type = submodule {
          options = {
            x = mkOption {
              type = int;
              description = "The x position of the monitor";
            };
            y = mkOption {
              type = int;
              description = "The y position of the monitor";
            };
          };
        };
      };
      rotation = mkOption {
        type = int;
        description = "The rotation of the monitor";
      };
    };
  };
in {
  options = {
    monitors = mkOption {
      type = attrsOf monitor;
    };

    custom = {
      backlight.enable = mkEnableOption "Backlight" // {default = true;};
      battery.enable = mkEnableOption "Battery" // {default = isLaptop;};
      wifi.enable = mkEnableOption "Wifi" // {default = isLaptop;};
    };
  };

  config.lib.monitors = {
    mainMonitorName =
      builtins.head (builtins.filter (name: config.monitors.${name}.isMain) (builtins.attrNames config.monitors));
    otherMonitorsNames =
      builtins.filter (name: !config.monitors.${name}.isMain) (builtins.attrNames config.monitors);
    mainMonitor = config.monitors.${config.lib.monitors.mainMonitorName};
  };
}
