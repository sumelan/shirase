{ lib, config, ... }:
let
  monitor = lib.types.submodule {
    options = {
      isMain = lib.mkOption {
        type = lib.types.bool;
        description = "Whether the monitor is the main one";
        default = false;
      };
      scale = lib.mkOption {
        type = lib.types.float;
        description = "The scale of the monitor";
        default = 1.0;
      };
      mode = lib.mkOption {
        type = lib.types.submodule {
          options = {
            width = lib.mkOption {
              type = lib.types.int;
              description = "The width of the monitor";
            };
            height = lib.mkOption {
              type = lib.types.int;
              description = "The height of the monitor";
            };
            refresh = lib.mkOption {
              type = lib.types.float;
              description = "The refresh rate of the monitor";
            };
          };
        };
      };
      position = lib.mkOption {
        type = lib.types.submodule {
          options = {
            x = lib.mkOption {
              type = lib.types.int;
              description = "The x position of the monitor";
            };
            y = lib.mkOption {
              type = lib.types.int;
              description = "The y position of the monitor";
            };
          };
        };
      };
      rotation = lib.mkOption {
        type = lib.types.int;
        description = "The rotation of the monitor";
      };
    };
  };
in

{
  options.monitors = lib.mkOption {
    type = lib.types.attrsOf monitor;
  };
  options.mainMonitorName = lib.mkOption {
    type = lib.types.str;
  };
  options.otherMonitorsNames = lib.mkOption {
    type = lib.types.listOf lib.types.str;
  };

  config.mainMonitorName =
    builtins.attrNames config.monitors
    |> builtins.filter (name: config.monitors.${name}.isMain)
    |> builtins.head;
  config.otherMonitorsNames =
    builtins.attrNames config.monitors |> builtins.filter (name: !config.monitors.${name}.isMain);
}
