{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.custom = with lib; {
    mpv.enable = mkEnableOption "mpv" // {
      default = true;
    };
  };

  config = lib.mkIf config.custom.mpv.enable {
    home.packages = with pkgs; [ 
      mpv
      ffmpeg
    ];

    custom.persist = {
      home.directories = [
        ".local/state/mpv" # watch later
      ];
    };
  };
}
