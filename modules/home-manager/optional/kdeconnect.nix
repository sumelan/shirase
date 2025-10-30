{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  options.custom = {
    kdeconnect.enable = mkEnableOption "kdeconnect";
  };

  config = mkIf config.custom.kdeconnect.enable {
    services.kdeconnect = {
      enable = true;
      indicator = true;
    };

    custom.persist = {
      home.directories = [
        ".config/kdeconnect"
        ".cache/kdeconnect.app"
        ".cache/kdeconnect.daemon"
      ];
    };
  };
}
