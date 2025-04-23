{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.custom = with lib; {
    psst = {
      enable = mkEnableOption "Fast and multi-platform Spotify client with native GUI";
    };
  };

  config = lib.mkIf config.custom.psst.enable {
    home.packages = with pkgs; [
      psst
    ];

    programs.niri.settings.window-rules = [
      {
        matches = [ { app-id = "^(Psst-gui)$"; } ];
        default-column-width = {
          proportion = 0.5;
        };
      }
    ];

    custom.persist = {
      home.directories = [
        ".config/Psst"
        ".cache/Psst"
      ];
    };
  };
}
