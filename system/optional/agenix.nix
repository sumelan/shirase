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

  config = lib.mkIf config.custom.agenix.enable {
    environment.systemPackages = [ inputs.agenix.packages."${pkgs.system}".default ];

    age.secrets.audiobookshelf = {
      file = ../../secrets/dynu-token.age;
    };
  };
}
