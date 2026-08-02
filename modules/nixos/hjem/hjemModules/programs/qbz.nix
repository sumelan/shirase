{lib, ...}: let
  inherit (lib) mkIf mkEnableOption mkPackageOption;
in {
  flake.custom.hjemModules.qbz = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.rum.programs.qbz;
  in {
    options.rum = {
      programs.qbz = {
        enable =
          mkEnableOption
          "A native, full-featured hi-fi Qobuz desktop player for Linux, with fast, bit-perfect audio playback";
        package = mkPackageOption pkgs "qbz" {};
      };
    };

    config = mkIf cfg.enable {
      packages = [cfg.package];
    };
  };
}
