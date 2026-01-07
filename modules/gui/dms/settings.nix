_: let
  inherit (builtins) fromJSON readFile;
in {
  flake.modules.homeManager.default = _: {
    programs.dank-material-shell = {
      settings = fromJSON (readFile ./settings.json);
      session = fromJSON (readFile ./session.json);
    };
  };
}
