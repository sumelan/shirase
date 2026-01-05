_: let
  inherit (builtins) fromJSON readFile;
in {
  flake.modules.homeManager.default = _: {
    programs.dank-material-shell = {
      default = {
        settings = fromJSON (readFile ./settings.json);
        session = fromJSON (readFile ./session.json);
      };
    };
  };
}
