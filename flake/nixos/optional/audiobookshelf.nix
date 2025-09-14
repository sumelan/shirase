{
  lib,
  config,
  user,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkOption
    mkIf
    optional
    ;

  inherit
    (lib.types)
    str
    ;
  cfg = config.custom.audiobookshelf;
in {
  options.custom = {
    audiobookshelf = {
      enable = mkEnableOption "audiobookshelf";
      nginx = {
        enable = mkEnableOption "nginx";
        domain = mkOption {
          type = str;
          default = "sakurairo.ddnsfree.com";
        };
        provider = mkOption {
          type = str;
          default = "dynu";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    services.audiobookshelf = {
      enable = true;
      host = "0.0.0.0"; # "127.0.0.1" means localhost only
      port = 8234;
      openFirewall = true;
    };

    services.nginx = mkIf cfg.nginx.enable {
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

    security.acme = mkIf cfg.nginx.enable {
      acceptTerms = true;
      defaults.email = config.hm.profiles.${user}.email;
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

    networking.firewall = mkIf cfg.nginx.enable {
      allowedTCPPorts = [
        80
        443
        59010
        59011
      ];
    };

    custom.persist = {
      root.directories =
        [
          "/var/lib/audiobookshelf"
        ]
        ++ (optional cfg.nginx.enable "/var/lib/acme");
    };
  };
}
