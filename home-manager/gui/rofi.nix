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

    home.packages = [
      # NOTE: rofi-power-menu only works for powermenuType = 4!
      (pkgs.custom.rofi-power-menu.override { hasWindows = config.custom.mswindows; })
    ] ++ (lib.optionals config.custom.wifi.enable [ pkgs.custom.rofi-wifi-menu ]);
  };
}
