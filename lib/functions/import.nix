{pkgs}: let
  inherit (pkgs.lib) concatMap hasPrefix hasSuffix;
in rec {
  tree = dir: {
    imports =
      concatMap
      (name: let
        p = dir + "/${name}";
      in
        if hasPrefix "_" name
        then []
        else if (builtins.readFileType p) == "directory"
        then (tree p).imports
        else if hasSuffix ".nix" name
        then [p]
        else [])
      (builtins.attrNames (builtins.readDir dir));
  };
}
