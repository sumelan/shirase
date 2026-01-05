_: {
  perSystem = {pkgs, ...}: {
    packages.dms-plugins = (pkgs.callPackage ../_sources/generated.nix {}).dms-plugins.src;
  };
}
