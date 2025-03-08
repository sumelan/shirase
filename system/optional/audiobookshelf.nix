{ 
  lib,
  config,
  ...
}:
{
  options.custom = with lib; {
    audiobookshelf.enable = mkEnableOption "Enable audiobookshelf";
  };

  config = lib.mkIf config.custom.audiobookshelf.enable {
    services.audiobookshelf = {
      enable = true;
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
