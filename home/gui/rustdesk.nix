{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.custom = with lib; {
    rustdesk.enable = mkEnableOption "rustdesk";
  };

  config = lib.mkIf config.custom.rustdesk.enable {
    home.packages = [ pkgs.rustdesk-flutter ];
  };
}
