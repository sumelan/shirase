{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.custom = with lib; {
    mpv.enable = mkEnable option "mpv";
  };

  config = lib.mkIf config.custom.mpv.enable {
    home.packages = [ pkgs.mpv ];
  };
}
