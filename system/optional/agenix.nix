{
  lib,
  config,
  ...
}:
{
  options.custom = with lib; {
    agenix.enable = mkEnableOption "agenix" // {
      default = config.custom.audiobookshelf.nginx.enable;
    };
  };

  config = lib.mkIf config.custom.agenix.enable {
    age.secrets.api-key = {
      file = ../../secrets/api-key.age;
      owner = "nginx";
      group = config.services.nginx.group;
    };
  };
}
