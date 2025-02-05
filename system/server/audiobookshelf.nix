{ 
  lib,
  config,
  ...
}:
{
  options.custom = with lib; {
    abs.enable = mkEnableOption "Enable audiobookshelf";
  };

  config = lib.mkIf config.custom.abs.enable {
    services.audiobookshelf = {
      enable = true;
      port = 8234;
      openFirewall = true;
    };
  };
}
