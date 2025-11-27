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
    kdeconnect.enable = mkEnableOption "kdeconnect";
  };

  config = mkIf config.custom.kdeconnect.enable {
    services.kdeconnect = {
      enable = true;
      indicator = true;
    };

    programs.niri.settings.window-rules = [
      {
        matches = singleton {
          app-id = "^org.kde.kdeconnect-indicator$";
        };
        open-floating = true;
      }
    ];

    custom.persist = {
      home = {
        directories = [
          ".config/kdeconnect"
        ];
        cache.directories = [
          ".cache/kdeconnect.app"
          ".cache/kdeconnect.daemon"
        ];
      };
    };
  };
}
