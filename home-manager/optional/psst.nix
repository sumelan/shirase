{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.custom = with lib; {
    psst = {
      enable = mkEnableOption "psst - spotify client";
    };
  };

  config = lib.mkIf config.custom.psst.enable {
    home.packages = with pkgs; [
      psst
    ];

    programs.niri.settings.window-rules = [
      {
        matches = [ { app-id = "^(psst-gui)$"; } ];
        default-column-width = {
          proportion = 0.6;
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
