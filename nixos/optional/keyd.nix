{
  lib,
  config,
  isLaptop,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    ;
in {
  options.custom = {
    keyd.enable =
      mkEnableOption "keyd" // {default = isLaptop;};
  };

  config = mkIf config.custom.keyd.enable {
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
