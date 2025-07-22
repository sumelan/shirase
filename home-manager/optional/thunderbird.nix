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
        matches = lib.singleton {
          app-id = "^(thunderbird)$";
        };
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
