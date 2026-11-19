{functions, ...}: let
  inherit (functions.import) tree;
in {
  imports = [
    (tree ./configs)
  ];
}
