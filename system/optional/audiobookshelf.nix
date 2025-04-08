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
          default = "sakurairo.ddnsfree.com";
        };
        provider = mkOption {
          type = types.str;
          default = "dynu";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.audiobookshelf = {
      enable = true;
      port = 8234;
      openFirewall = true;
    };

    services.nginx = lib.mkIf cfg.nginx.enable {
      enable = true;
      recommendedProxySettings = true;
      virtualHosts = {
        "${cfg.nginx.domain}" = {
          forceSSL = true; # Optional, but highly recommended
          locations."/" = {
            proxyPass = "http://127.0.0.1:${builtins.toString config.services.audiobookshelf.port}";
            proxyWebsockets = true;
            extraConfig = ''
              proxy_redirect http:// $scheme://;
            '';
          };
          useACMEHost = "${cfg.nginx.domain}"; # Optional, but highly recommended
        };
      };
      # Prevent 413 Request Entity Too Large error
      # by increasing the maximum allowed size of the client request body
      # For example, set it to 10 GiB
      clientMaxBodySize = "1024M";
    };

    security.acme = lib.mkIf cfg.nginx.enable {
      acceptTerms = true;
      defaults.email = "bathys@proton.me";
      certs."${cfg.nginx.domain}" = {
        domain = "${cfg.nginx.domain}";
        # extraDomainNames = [
        # "audiobookshelf.${cfg.nginx.domain}"
        # ];
        group = config.services.nginx.group;
        dnsProvider = "${cfg.nginx.provider}";
        dnsPropagationCheck = true;
        credentialsFile = config.age.secrets.api-key.path;
      };
    };

    custom.persist = {
      root.directories = [
        "/var/lib/audiobookshelf"
        "/var/lib/acme"
      ];
    };
  };
}
