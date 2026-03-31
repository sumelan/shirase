_: let
  inherit (builtins) readFile;
in {
  flake.modules.nixos.hjem-gui = _: {
    hj.xdg.config.files = {
      "DankMaterialShell/settings.json".text = readFile ./settings.json;
    };
  };
}
