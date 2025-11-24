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
    singleton
    ;
in {
  options.custom = {
    vlc.enable = mkEnableOption "vlc";
  };

  config = mkIf config.custom.vlc.enable {
    home.packages = [pkgs.vlc];

    programs.niri.settings.window-rules = [
      {
        matches = singleton {
          app-id = "^vlc$";
        };
        open-floating = true;
        default-column-width.proportion = 0.50;
        default-window-height.proportion = 0.50;
        opacity = 1.0;
      }
    ];

    custom.persist = {
      home.directories = [".config/vlc"];
    };
  };
}
