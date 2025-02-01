{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib;
let
  cfg = config.custom.agenix;
in
{
  options.custom.agenix = {
    enable = mkEnableOption "Enable encryption using agenix";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ inputs.agenix.packages."${pkgs.system}".default ];
    age.secrets.nextcloud = {
      file = ../secrets/nextcloud.age;
      owner = "nextcloud";
      group = "nextcloud";
    };
    age.secrets.dns-token = {
      file = ../secrets/dns-token.age;
    };
  };
}
