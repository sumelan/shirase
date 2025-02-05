{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.custom = with lib; {
    foliate.enable = mkEnableOption "foliate";
  };

  config = lib.mkIf config.custom.foliate.enable {
    home.packages = [ pkgs.foliate ];
  };
}
