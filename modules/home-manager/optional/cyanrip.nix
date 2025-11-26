{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  options.custom = {
    cyanrip.enable = mkEnableOption "cyanrip";
  };

  config = mkIf config.custom.cyanrip.enable {
    home.packages = [pkgs.cyanrip];
  };
}
