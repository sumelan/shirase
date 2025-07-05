{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.agenix.nixosModules.default
  ];

  options.custom = {
    agenix.enable = lib.mkEnableOption "agenix" // {
      default = config.custom.audiobookshelf.nginx.enable;
    };
  };

  config = {
    environment.systemPackages = [ inputs.agenix.packages."${pkgs.system}".default ];
    age.secrets.api-key = lib.mkIf config.custom.agenix.enable {
      file = ../../secrets/api-key.age;
      owner = "nginx";
      inherit (config.services.nginx) group;
    };
  };
}
