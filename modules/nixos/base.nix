{functions, ...}: let
  inherit (functions.import) tree;
in {
  imports = [
    (tree ./core)

    ./hardware/common.nix
    ./hjem/config.nix
    ./secrets/nix-secrets.nix
  ];
}
