{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  options.custom = with lib; {
    agenix.enable = mkEnableOption "agenix" // {
      default = config.custom.audiobookshelf.nginx.enable;
    };
  };

  config = {
    environment.systemPackages = [ inputs.agenix.packages."${pkgs.system}".default ];
    age.secrets.api-key = lib.mkIf config.custom.agenix.enable {
      file = ../../secrets/api-key.age;
      owner = "nginx";
      group = config.services.nginx.group;
    };
  };
}
