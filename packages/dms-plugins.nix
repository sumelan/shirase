_: {
  perSystem = {pkgs, ...}: let
    inherit (pkgs) callPackage;
    nvSrc = ../_sources/generated.nix;
  in {
    packages = {
      # official-plugins
      dms-plugins = (callPackage nvSrc {}).dms-plugins.src;
      dms-screen-recorder = (callPackage nvSrc {}).dms-screen-recorder.src;
      dms-display-mirror = (callPackage nvSrc {}).dms-display-mirror.src;
    };
  };
}
