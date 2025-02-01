{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.custom = with lib; {
    mpv.enable = mkEnableOption "mpv";
  };

  config = lib.mkIf config.custom.mpv.enable {
    home.packages = [ pkgs.mpv ];
  };
}
