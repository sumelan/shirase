{
  lib,
  config,
  ...
}:
let
  cfg = config.custom.audiobookshelf;
in
{
  options.custom = with lib; {
    audiobookshelf = {
      enable = mkEnableOption "audiobookshelf";

      nginx = {
        enable = mkEnableOption "nginx";
        domain = mkOption {
          type = types.str;
          default = "";
        };
        provider = mkOption {
          type = types.str;
          default = "";
        };
      };

      https = {
        enable = mkEnableOption "https" // {
          default = config.custom.audiobookshelf.nginx.enable;
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # audiobookshelf base settings
    services.audiobookshelf = {
      enable = true;
      port = 8234;
      openFirewall = true;
    };

    # if nginx enable
    services.nginx = lib.mkIf cfg.nginx.enable {
      # Prevent 413 Request Entity Too Large error
      # by increasing the maximum allowed size of the client request body
      # For example, set it to 10 GiB
      clientMaxBodySize = "1024M";
      virtualHosts = {
        "audiobookshelf.${cfg.nginx.domain}" = lib.mkMerge [
          {
            locations."/" = {
              proxyPass = "http://localhost:8234/";
              proxyWebsockets = true;
            };
          }
          # additional nginx settings if https enable
          (lib.mkIf cfg.https.enable {
            forceSSL = true;
            useACMEHost = "${cfg.domain}";
          })
        ];
      };
    };
    users.users.nginx.extraGroups = lib.mkIf cfg.nginx.enable [ "acme" ];

    security.acme = lib.mkIf cfg.https.enable {
      acceptTerms = true;
      defaults.email = "bathys@proton.me";
      certs."${cfg.nginx.domain}" = {
        domain = "${cfg.nginx.domain}";
        extraDomainNames = [
          "audiobookshelf.${cfg.nginx.domain}"
        ];
        dnsProvider = "${cfg.nginx.provider}";
        dnsPropagationCheck = true;
        credentialsFile = config.age.secrets.dns-token.path;
      };
    };
    custom.persist = {
      root.directories = [
        "/var/lib/audiobookshelf"
      ];
    };
  };
}
