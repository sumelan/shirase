{inputs, ...}: {
  imports = [
    (inputs.import-tree ./core)

    ./hardware/common.nix
    ./hjem/hjem.nix
    ./secrets/nix-secrets.nix
  ];
}
