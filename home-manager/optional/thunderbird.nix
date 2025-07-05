{
  lib,
  config,
  ...
}:
{
  options.custom = {
    thunderbird = {
      enable = lib.mkEnableOption "thunderbird";
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
        default-column-width.proportion = 0.7;
        block-out-from = "screen-capture";
      }
    ];

    custom.persist = {
      home.directories = [
        ".thunderbird"
      ];
    };
  };
}
