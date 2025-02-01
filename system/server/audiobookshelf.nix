{ 
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.custom.server.audiobookshelf;
in {
  options.custom.server.audiobookshelf = {
    enable = mkEnableOption "Enable audiobookshelf";
  };

  config = mkIf cfg.enable {
    services.audiobookshelf = {
      enable = true;
      port = 8234;
      openFirewall = true;
    };
  };
}
