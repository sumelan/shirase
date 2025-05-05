{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.custom = with lib; {
    inkscape.enable = mkEnableOption "inkscape" // {
      default = config.custom.krita.enable;
    };
  };

  config = lib.mkIf config.custom.inkscape.enable {
    home.packages = with pkgs; [ inkscape ];

    programs.niri.settings.window-rules = [
      {
        matches = [ { app-id = "^(org.inkscape.Inkscape)$"; } ];
        open-fullscreen = true;
        open-on-output = "HDMI-A-2";
        opacity = 1.00;
      }
    ];

    custom.persist = {
      home.directories = [
        ".config/inkscape"
      ];
    };
  };
}
