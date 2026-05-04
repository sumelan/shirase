_: {
  flake.modules.nixos.keyd = _: {
    services.keyd = {
      enable = true;
      keyboards = {
        default = {
          ids = ["*"];
          settings = {
            main = {
              #  shift = "oneshot(shift)"; # you can now simply tap shift instead of having to hold it.
              #  meta = "oneshot(meta)";
              #  control = "oneshot(control)";
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
