{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.custom.audiobookshelf;
in {
  options.custom = {
    audiobookshelf = {
      enable = mkEnableOption "audiobookshelf";
    };
  };

  config = mkIf cfg.enable {
    services.audiobookshelf = {
      enable = true;
      host = "0.0.0.0"; # "127.0.0.1" means localhost only
      port = 8234;
      openFirewall = true;
    };

    custom.persist = {
      root.directories = [
        "/var/lib/audiobookshelf"
      ];
    };
  };
}
