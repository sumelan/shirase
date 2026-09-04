_: {
  flake.modules.nixos.gui = _: {
    programs = {
      mango = {
        enable = true;
      };
    };
  };
}
