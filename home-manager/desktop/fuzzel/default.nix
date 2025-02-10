{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.custom = with lib; {
    fuzzel.enable = mkEnableOption "fuzzel" // {
      default = config.custom.niri.enable;
    };
  };

  config = lib.mkIf config.custom.fuzzel.enable {
    home = {
      packages = with pkgs; [
        fuzzel
      ];
      file.".config/fuzzel/fuzzel.ini".source = ./fuzzel.ini;
    };
  };
}
