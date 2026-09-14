{
  config,
  lib,
  ...
}: let
  inherit (config) flake;
in {
  flake.modules.nixos.gui = {
    config,
    pkgs,
    ...
  }: let
    local = flake.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    programs = {
      mango = {
        enable = true;
        package = local.mango;
      };

      uwsm = {
        enable = true;
        waylandCompositors = {
          mango = {
            prettyName = "MangoWM";
            comment = "MangoWM managed by UWSM";
            binPath = lib.getExe config.programs.mango.package;
          };
        };
      };
    };
  };
}
