{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.custom = {
    kooha.enable = lib.mkEnableOption "kooha" // {
      default = config.custom.maomao.enable;
    };
  };

  config = lib.mkIf config.custom.kooha.enable {
    home.packages = with pkgs; [ kooha ];
  };
}
