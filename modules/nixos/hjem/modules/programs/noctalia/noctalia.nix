{inputs, ...}: {
  flake.custom.hjemModules.noctalia = _: {
    imports = [inputs.noctalia.hjemModules.default];

    programs.noctalia = {
      enable = true;
      systemd.enable = true;
    };

    xdg.state.files = {
      "noctalia/.setup-complete" = {
        permissions = "666";
        text = "";
        type = "copy";
      };
    };
  };
}
