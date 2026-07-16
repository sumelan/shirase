_: {
  flake.modules.nixos.default = {dotfile, ...}: {
    programs.tack = {
      enable = true;
    };

    environment.variables = {
      TACK_DIR = "${dotfile}/.tack";
    };
  };
}
