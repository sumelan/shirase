{
  lib,
  config,
  ...
}:
let
  cfg = config.custom.nginx;
in
{
  options.custom = {
    nginx = with lib; {
      enable = mkEnableOption "Enable nginx and acme" // {
        default = config.custom.audiobookshelf.enable || config.custon.nextcloud.enable;
      };
      domain = mkOption {
        type = types.str;
        default = "";
      };
      provider = mkOption {
        type = types.str;
        default = "";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.nginx.virtualHosts = {
      "nextcloud.${cfg.domain}" = {
        useACMEHost = "${cfg.domain}";
        forceSSL = true;
      };
      "audiobookshelf.${cfg.domain}" = {
        useACMEHost = "${cfg.domain}";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:8234/";
          proxyWebsockets = true;
        };
      };
    };
    # Prevent 413 Request Entity Too Large error
    # by increasing the maximum allowed size of the client request body
    # For example, set it to 10 GiB
    services.nginx.clientMaxBodySize = "1024M";
    users.users.nginx.extraGroups = ["acme"];

    security.acme = {
      acceptTerms = true;
      defaults.email = "bathys@proton.me";
      certs."${cfg.domain}" = {
        domain = "${cfg.domain}";
        extraDomainNames = [
          "nextcloud.${cfg.domain}"
          "audiobookshelf.${cfg.domain}"
        ];
        dnsProvider = "${cfg.provider}";
        dnsPropagationCheck = true;
        credentialsFile = config.age.secrets.dns-token.path;
      };
    };
  };
}
