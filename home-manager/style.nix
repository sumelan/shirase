{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkOption
    types
    ;
  cfg = config.custom.stylix;
in {
  options.custom = with types; {
    stylix = {
      cursor = {
        package = mkOption {
          type = package;
          default = pkgs.bibata-cursors;
        };
        name = mkOption {
          type = str;
          default = "Bibata-Modern-Ice";
        };
      };
      icons = {
        package = mkOption {
          type = package;
          default = pkgs.papirus-icon-theme;
        };
        light = mkOption {
          type = str;
          default = "Papirus-Light";
        };
        dark = mkOption {
          type = str;
          default = "Papirus-Dark";
        };
      };
    };
  };

  config = {
    stylix = {
      enable = true;
      autoEnable = true;
      polarity = "dark";
      # unnecessary module
      targets = {
        kde.enable = false;
        blender.enable = false;
        forge.enable = false;
      };
      cursor = {
        inherit (cfg.cursor) package name;
        size = 48;
      };

      fonts = {
        sansSerif = {
          package = pkgs.geist-font;
          name = "Geist";
        };
        serif = {
          package = pkgs.geist-font;
          name = "Geist";
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
          applications = 13;
          terminal = 13;
          desktop = 13;
          popups = 12;
        };
      };

      icons = {
        enable = true;
        inherit (cfg.icons) package light dark;
      };

      opacity = {
        desktop = 0.95;
        popups = 0.85;
        terminal = 1.0;
      };
    };

    home = {
      packages = with pkgs; [
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
      ];
    };
  };
}
