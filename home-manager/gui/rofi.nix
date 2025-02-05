{
  config,
  lib,
  pkgs,
  ...
}:
let
  rofiThemes = pkgs.custom.rofi-themes;
in
{
  options.custom = with lib; {
    rofi = {
      theme = mkOption {
        type = types.nullOr (
          types.enum [
            "adapta"
            "arc"
            "black"
            "catppuccin"
            "cyberpunk"
            "dracula"
            "everforest"
            "gruvbox"
            "lovelace"
            "navy"
            "nord"
            "onedark"
            "paper"
            "solarized"
            "tokyonight"
            "yousai"
          ]
        );
        default = null;
        description = "Rofi launcher theme";
      };
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
      package = pkgs.rofi-wayland.override {
        plugins = [ rofiThemes ];
      };
    };

    home.packages = [
      # NOTE: rofi-power-menu only works for powermenuType = 4!
      (pkgs.custom.rofi-power-menu.override { hasWindows = config.custom.mswindows; })
    ] ++ (lib.optionals config.custom.wifi.enable [ pkgs.custom.rofi-wifi-menu ]);
  };
}
