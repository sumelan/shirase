{config, ...}: {
  flake.modules.nixos.gui = {pkgs, ...}: let
    local = config.flake.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    programs = {
      mango = {
        enable = true;
        package = local.mango;
      };
    };
  };
}
