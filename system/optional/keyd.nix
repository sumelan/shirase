{
  lib,
  config,
  isLaptop,
  ...
}: {
  options.custom = {
    keyd.enable =
      lib.mkEnableOption "keyd"
      // {
        default = isLaptop;
      };
  };

  config = lib.mkIf config.custom.keyd.enable {
    services.keyd = {
      enable = true;
      keyboards = {
        default = {
          ids = ["*"];
          settings = {
            main = {
              #   shift = "oneshot(shift)"; # you can now simply tap shift instead of having to hold it.
              #   meta = "oneshot(meta)";
              #   control = "oneshot(control)";
              leftalt = "alt";
              rightalt = "altgr";

              capslock = "`";
              menu = "shift";
            };
          };
        };
      };
    };
  };
}
