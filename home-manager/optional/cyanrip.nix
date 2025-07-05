{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.custom = {
    cyanrip.enable = lib.mkEnableOption "cyanrip";
  };

  config = lib.mkIf config.custom.cyanrip.enable {
    home.packages = with pkgs; [ cyanrip ];
  };
}
