{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.custom = with lib; {
    rmpc.enable = mkEnableOption "rmpc" // {
      default = true;
    };
  };

  config = lib.mkIf config.custom.rmpc.enable {
    home.packages = with pkgs; [ rmpc ];

    xdg.configFile = {
      "rmpc/config.ron".source = ./config.ron;
      "rmpc/themes/mytheme.ron".source = ./mytheme.ron;
    };
  };
}
