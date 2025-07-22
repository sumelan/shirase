{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.custom = {
    picard.enable = lib.mkEnableOption "picard" // {
      default = config.custom.cyanrip.enable;
    };
  };

  config = lib.mkIf config.custom.picard.enable {
    home.packages = with pkgs; [ picard ];
  };
}
