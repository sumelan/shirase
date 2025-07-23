{
  lib,
  config,
  ...
}:
let
  cfg = config.custom.audiobookshelf;
in
{
  options.custom = {
    audiobookshelf = {
      enable = lib.mkEnableOption "audiobookshelf";
      nginx = {
        enable = lib.mkEnableOption "nginx";
        domain = lib.mkOption {
          type = lib.types.str;
          default = "sakurairo.ddnsfree.com";
        };
        provider = lib.mkOption {
          type = lib.types.str;
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
      clientMaxBodySize = "10240M";
    };

    security.acme = lib.mkIf cfg.nginx.enable {
      acceptTerms = true;
      defaults.email = "bathys@proton.me";
      certs."${cfg.nginx.domain}" = {
        domain = "${cfg.nginx.domain}";
        # extraDomainNames = [
        # "audiobookshelf.${cfg.nginx.domain}"
        # ];
        inherit (config.services.nginx) group;
        dnsProvider = "${cfg.nginx.provider}";
        dnsPropagationCheck = true;
        credentialsFile = config.age.secrets.api-key.path;
      };
    };

    networking.firewall = lib.mkIf cfg.nginx.enable {
      allowedTCPPorts = [
        80
        443
        59010
        59011
      ];
      allowedUDPPorts = [
        59010
        59011
      ];
    };

    custom.persist = {
      root.directories = [
        "/var/lib/audiobookshelf"
      ]
      ++ (lib.optional cfg.nginx.enable "/var/lib/acme");
    };
  };
}
