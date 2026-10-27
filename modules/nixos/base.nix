{inputs, ...}: {
  imports = [
    (inputs.import-tree ./core)

    ./hardware/common.nix
    ./hjem/config.nix
    ./secrets/nix-secrets.nix
  ];
}
