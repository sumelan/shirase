{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.custom.stylix;
in
{
  options.custom = with lib; {
    stylix = {
      cursor = {
        package = mkOption {
          type = types.package;
          default = pkgs.bibata-cursors;
        };
        name = mkOption {
          type = types.str;
          default = "Bibata-Modern-Ice";
        };
      };
      icon = {
        package = mkOption {
          type = types.package;
          default = pkgs.papirus-icon-theme;
        };
        lightName = mkOption {
          type = types.str;
          default = "Papirus-Light";
        };
        darkName = mkOption {
          type = types.str;
          default = "Papirus-Dark";
        };
      };
    };
  };

  config = {
    stylix = {
      enable = true;
      autoEnable = true;

      cursor = {
        package = cfg.cursor.package;
        name = cfg.cursor.name;
        size = 30;
      };

      fonts = {
        sansSerif = {
          package = pkgs.nerd-fonts.ubuntu;
          name = "Ubuntu Nerd Font";
        };
        serif = {
          package = pkgs.nerd-fonts.ubuntu;
          name = "Ubuntu Nerd Font";
        };
        monospace = {
          package = pkgs.maple-mono.NF;
          name = "Maple Mono NF";
        };
        emoji = {
          package = pkgs.noto-fonts-emoji;
          name = "Noto Color Emoji";
        };
        sizes = {
          applications = 12;
          terminal = 12;
          desktop = 13;
          popups = 13;
        };
      };

      iconTheme = {
        enable = true;
        package = cfg.icon.package;
        light = cfg.icon.lightName;
        dark = cfg.icon.darkName;
      };

      opacity = {
        desktop = 0.95;
        popups = 0.85;
        terminal = 1.0;
      };
    };

    # other font packages
    home.packages = with pkgs; [
      # japanese
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
    ];
  };
}
