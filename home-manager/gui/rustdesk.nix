{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.custom = with lib; {
    rustdesk.enable = mkEnableOption "rustdesk";
  };

  config = lib.mkIf config.custom.rustdesk.enable {
    home.packages = [ pkgs.rustdesk-flutter ];

    custom.persist = {
      home.directories = [
        ".config/rustdesk"
      ];
      cache.directories = [
        ".local/share/logs/RustDesk"
      ];
    };
  };
}
