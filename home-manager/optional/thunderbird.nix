{
  lib,
  config,
  ...
}:
{
  options.custom = with lib; {
    thunderbird = {
      enable = mkEnableOption "thunderbird";
    };
  };

  config = lib.mkIf config.custom.thunderbird.enable {
    programs.thunderbird = {
      enable = true;
      profiles = {
        "Gmail" = {
          isDefault = true;
        };
      };
    };

    programs.niri.settings.window-rules = [
      {
        matches = [ { app-id = "^(thunderbird)$"; } ];
        default-column-width = {
          proportion = 0.5;
        };
      }
    ];

    custom.persist = {
      home.directories = [
        ".thunderbird"
      ];
    };
  };
}
