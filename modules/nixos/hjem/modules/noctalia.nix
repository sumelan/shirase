{inputs, ...}: {
  flake.custom.hjemModules.noctalia = _: {
    imports = [inputs.noctalia.hjemModules.default];
  };
}
