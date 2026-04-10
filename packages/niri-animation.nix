_: {
  perSystem = {pkgs, ...}: {
    packages.niri-animation = (pkgs.callPackage ../_sources/generated.nix {}).niri-animation.src;
  };
}
