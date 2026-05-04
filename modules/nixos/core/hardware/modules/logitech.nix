_: {
  flake.modules.nixos.logitech = _: {
    hardware.logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
  };
}
