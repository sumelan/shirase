_: let
  inherit (builtins) readFile;
in {
  flake.modules.nixos.dms = _: {
    hj.xdg.config.files = {
      "DankMaterialShell/settings.json".text = readFile ./settings.json;
    };
  };
}
