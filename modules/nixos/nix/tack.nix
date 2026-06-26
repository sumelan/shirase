_: {
  flake.modules.nixos.default = _: {
    programs.tack = {
      enable = true;
    };
  };
}
