_: let
  inherit (builtins) readFile;
in {
  flake.modules.homeManager.default = _: {
    xdg.configFile = {
      "DankMaterialShell/settings.json".text = readFile ./settings.json;
    };
  };
}
