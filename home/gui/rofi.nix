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
    theme = "${config.xdg.cacheHome}/wallust/rofi.rasi";
    };
    # NOTE: rofi-power-menu only works for powermenuType = 4!
    home.packages = (lib.optionals config.custom.wifi.enable [
      pkgs.custom.rofi-wifi-menu
    ]);

    # add blur for rofi shutdown
    wayland.windowManager.hyprland.settings = {
      layerrule = [
        "blur,rofi"
        "dimaround,rofi"
        "ignorealpha 0,rofi"
      ];

      # force center rofi on monitor
      windowrulev2 = [
        "float,class:(Rofi)"
        "center,class:(Rofi)"
        "rounding 12,class:(Rofi)"
        "dimaround,class:(Rofi)"
      ];
    };
  };
}
