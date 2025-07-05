{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.custom = {
    rustdesk.enable = lib.mkEnableOption "rustdesk";
  };

  config = lib.mkIf config.custom.rustdesk.enable {
    home.packages = with pkgs; [ rustdesk-flutter ];

    custom.persist = {
      home = {
        directories = [
          ".config/rustdesk"
        ];
        cache.directories = [
          ".local/share/logs/RustDesk"
        ];
      };
    };
  };
}
