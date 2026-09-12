{config, ...}: {
  flake.modules.nixos.gui = {pkgs, ...}: let
    local = config.flake.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    programs = {
      mango = {
        enable = true;
        package = local.mango;
      };
      xwayland.enable = false;

      uwsm = {
        enable = true;
        waylandCompositors = {
          mango = {
            prettyName = "MangoWM";
            comment = "MangoWM managed by UWSM";
            binPath = "/run/current-system/sw/bin/mango";
          };
        };
      };
    };
  };
}
