{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.custom = with lib; {
    cyanrip.enable = mkEnableOption "cyanrip";
  };

  config = lib.mkIf config.custom.cyanrip.enable {
    home.packages = with pkgs; [ cyanrip ];
  };
}
