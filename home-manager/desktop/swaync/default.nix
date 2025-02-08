{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.custom = with lib; {
    swaync.enable = mkEnableOption "swaync" // {
      default = config.custom.niri.enable;
    };
    autostart = mkEnableOption "startup swaync daemon" // {
      default = config.custom.swaync.enable;
    };
  };

  config = lib.mkIf config.custom.swaync.enable {
    home = {
      file = {
        ".config/swaync/config.json".source = ./config.json;
        ".config/swaync/style.css".source = ./style.css;
      };

      packages = with pkgs; [
        swaynotificationcenter
      ];
    };
  };
}
