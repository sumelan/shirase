{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.custom = with lib; {
    youtube-music = {
      enable = mkEnableOption "Electron wrapper around YouTube Music";
    };
  };

  config = lib.mkIf config.custom.youtube-music.enable {
    home.packages = [ pkgs.youtube-music ];

    custom.persist = {
      home.directories = [
        ".config/YouTube Music"
      ];
    };
  };
}
