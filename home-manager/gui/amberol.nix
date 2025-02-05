{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.custom = with lib; {
    amberol.enable = mkEnableOption "amberol";
  };

  config = lib.mkIf config.custom.amberol.enable {
    home.packages = [ pkgs.amberol ];
  };
}
