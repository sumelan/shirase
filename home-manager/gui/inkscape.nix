{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.custom = with lib; {
    inkscape.enable = mkEnableOption "inkscape";
  };

  config = lib.mkIf config.custom.inkscape.enable {
    home.packages = [ pkgs.inkscape ];
  };
}
