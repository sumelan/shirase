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
  options.custom = {
    stylix = {
      cursor = {
        package = lib.mkOption {
          type = lib.types.package;
          default = pkgs.bibata-cursors;
        };
        name = lib.mkOption {
          type = lib.types.str;
          default = "Bibata-Modern-Ice";
        };
      };
      icon = {
        package = lib.mkOption {
          type = lib.types.package;
          default = pkgs.papirus-icon-theme;
        };
        lightName = lib.mkOption {
          type = lib.types.str;
          default = "Papirus-Light";
        };
        darkName = lib.mkOption {
          type = lib.types.str;
          default = "Papirus-Dark";
        };
      };
    };
  };

  config = {
    stylix = {
      enable = true;
      autoEnable = true;
      # unnecessary module
      targets = {
        kde.enable = false;
        blender.enable = false;
        forge.enable = false;
      };
      cursor = {
        inherit (cfg.cursor) package name;
        size = 28;
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
          package = pkgs.maple-mono.NF; # Maple Mono NF (Ligature hinted)
          name = "Maple Mono NF";
        };
        emoji = {
          package = pkgs.noto-fonts-color-emoji;
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
        inherit (cfg.icon) package;
        light = cfg.icon.lightName;
        dark = cfg.icon.darkName;
      };

      opacity = {
        desktop = 0.95;
        popups = 0.85;
        terminal = 1.0;
      };
    };
  };
}
