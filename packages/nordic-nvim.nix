_: {
  perSystem = {pkgs, ...}: {
    packages.nordic-nvim = (pkgs.callPackage ../_sources/generated.nix {}).nordic-nvim.src;
  };
}
