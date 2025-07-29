{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.custom = {
    qobuz-player.enable = lib.mkEnableOption "Tui, web and rfid player for Qobuz";
  };

  config = lib.mkIf config.custom.qobuz-player.enable {
    home.packages = with pkgs; [ custom.qobuz-player ];

    custom.persist = {
      home.directories = [
        ".local/share/qobuz-player"
      ];
    };
  };
}
