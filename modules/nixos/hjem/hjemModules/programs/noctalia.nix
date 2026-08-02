{inputs, ...}: {
  flake.custom.hjemModules.noctalia = {pkgs, ...}: let
    swash = inputs.swash.packages.${pkgs.stdenv.hostPlatform.system}.default;
  in {
    imports = [inputs.noctalia.hjemModules.default];

    packages = builtins.attrValues {
      inherit (pkgs) ddcutil mpvpaper gpu-screen-recorder;
      inherit swash;
    };
  };
}
