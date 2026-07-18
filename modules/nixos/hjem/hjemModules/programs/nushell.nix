{lib, ...}: let
  inherit (lib) mkPackageOption mkEnableOption;
in {
  flake.custom.hjemModules.nuhsell = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.rum.programs.nushell;
  in {
    options.rum = {
      programs.nushell = {
        enable = mkEnableOption "A new type of shell written in Rust";

        package = mkPackageOption pkgs "nushell" {};
      };
    };

    config = lib.mkIf cfg.enable {
      packages = [cfg.package];
    };
  };
}
