{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.custom = {
    vlc.enable = lib.mkEnableOption "vlc";
  };

  config = lib.mkIf config.custom.vlc.enable {
    home.packages = with pkgs; [ vlc ];

    custom.persist = {
      home.directories = [ ".config/vlc" ];
    };
  };
}
