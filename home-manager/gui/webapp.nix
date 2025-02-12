{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.custom.webapps;
in
{
  options.custom = with lib; {
    webapps = {
      enable = mkEnableOption "nix-webapps";
      appName = mkOption {
        type = types.str;
        default = "";
      };
      categories = mkOption {
        type = types.listOf types.str;
        default = [ "" ];
      };
      desktopName = mkOption {
        type = types.str;
        default = "";
      };
      icon = mkOption {
        type = types.path;
        default = ./icons/${cfg.appName}.svg;
      };
      url = mkOption {
        type = types.str;
        default = "";
      };
      class = mkOption {
        type = types.str;
        default = "";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      (pkgs.nix-webapps-lib.mkChromiumApp {
        appName = cfg.appName;
        categories = cfg.categories;
        desktopName = cfg.desktopName;
        icon = cfg.icon;
        url = cfg.url;
        class = cfg.class;
      })
    ];
  };
}
