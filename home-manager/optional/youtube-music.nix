{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    ;
in {
  options.custom = {
    youtube-music.enable = mkEnableOption "Electron wrapper around Youtube Music";
  };

  config = mkIf config.custom.youtube-music.enable {
    home.packages = [pkgs.youtube-music];

    custom.persist = {
      home.directories = [
        ".config/YouTube Music"
      ];
    };
  };
}
