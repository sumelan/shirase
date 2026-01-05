_: {
  perSystem = {pkgs, ...}: {
    packages.yazi-plugins = (pkgs.callPackage ../_sources/generated.nix {}).yazi-plugins.src;
  };
}
