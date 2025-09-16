{
  lib,
  config,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkOption
    mkIf
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

    custom.persist = {
      root.directories = [
        "/var/lib/audiobookshelf"
      ];
    };
  };
}
