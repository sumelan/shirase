{
  lib,
  config,
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
    thunderbird.enable = mkEnableOption "thunderbird";
  };

  config = mkIf config.custom.thunderbird.enable {
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
        matches = singleton {
          app-id = "^(thunderbird)$";
        };
        block-out-from = "screen-capture";
      }
    ];
  };
}
