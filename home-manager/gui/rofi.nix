{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.custom = with lib; {
    rofi = {
      width = mkOption {
        type = types.int;
        default = 800;
        description = "Rofi launcher width";
      };
    };
  };

  config = {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
    };

    home.packages = lib.mkIf config.custom.wifi.enable [
      pkgs.rofi-wifi-menu
    ];
  };
}
