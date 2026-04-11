_: {
  flake.modules.nixos.qmk = _: {
    hardware.keyboard.qmk = {
      enable = true;
      keychronSupport = false;
    };
  };
}
