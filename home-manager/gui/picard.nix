{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.custom = with lib; {
    picard.enable = mkEnableOption "picard"// {
      default = config.custom.cyanrip.enable;
    };
  };

  config = lib.mkIf config.custom.picard.enable {
    home.packages = with pkgs; [
      picard
    ];

    custom.persist = {
      home.directories = [
        ".config/MusicBrainz"
        ".cache/MusicBrainz"
      ];
    };
  };
}
