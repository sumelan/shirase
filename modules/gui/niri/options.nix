{lib, ...}: let
  inherit
    (builtins)
    head
    filter
    attrNames
    ;
  inherit (lib) mkOption;
  inherit
    (lib.types)
    bool
    attrsOf
    float
    int
    str
    submodule
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
  flake.modules.nixos.gui = {config, ...}: let
    cfg = config.custom.hardware.monitors;
    clib = config.lib.custom.hardware.monitors;
  in {
    options.custom = {
      hardware.monitors = mkOption {
        type = attrsOf monitor;
      };
      programs.niri = {
        xwayland = mkOption {
          type = bool;
          default = false;
        };
        screenshot.host = mkOption {
          type = str;
          default = "";
        };
      };
    };
    config.lib.custom.hardware.monitors = {
      mainMonitorName =
        head (filter (name: cfg.${name}.isMain) (attrNames cfg));
      otherMonitorsNames =
        filter (name: !cfg.${name}.isMain) (attrNames cfg);
      mainMonitor = cfg.${clib.mainMonitorName};
    };
  };
}
