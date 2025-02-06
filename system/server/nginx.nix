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
      enable = mkEnableOption "Enable nginx and acme";
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
    services.nginx.virtualHosts = lib.mkMerge [
      (lib.mkIf config.custom.nextcloud.enable {
        "nextcloud.${cfg.domain}" = {
          useACMEHost = "${cfg.domain}";
          forceSSL = true;
        };
      })
      (lib.mkIf config.custom.audiobookshelf.enbale {
        "audiobookshelf.${cfg.domain}" = {
          useACMEHost = "${cfg.domain}";
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://localhost:8234/";
            proxyWebsockets = true;
          };
        };
      })
    ];
    # Prevent 413 Request Entity Too Large error
    # by increasing the maximum allowed size of the client request body
    # For example, set it to 10 GiB
    services.nginx.clientMaxBodySize = "1024M";

    security.acme = {
      acceptTerms = true;
      defaults.email = "bathys@proton.me";
      certs."${cfg.domain}" = {
        domain = "${cfg.domain}";
        extraDomainNames = 
          lib.optional config.custom.nextcloud.enable [
            "nextcloud.${cfg.domain}"
          ]
          ++ lib.optional config.custom.audiobookshelf.enable [
            "audiobookshelf.${cfg.domain}"
          ];
        dnsProvider = "${cfg.provider}";
        dnsPropagationCheck = true;
        credentialsFile = config.age.secrets.dns-token.path;
      };
    };
    users.users.nginx.extraGroups = ["acme"];
  };
}
