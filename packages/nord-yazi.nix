_: {
  perSystem = {pkgs, ...}: {
    packages.nord-yazi = (pkgs.callPackage ../_sources/generated.nix {}).nord-yazi.src;
  };
}
