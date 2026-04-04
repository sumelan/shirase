_: let
  inherit (builtins) readFile;
in {
  flake.modules.nixos.gui = _: {
    hj.xdg.config.files = {
      "DankMaterialShell/settings.json".text = readFile ./settings.json;
    };
  };
}
