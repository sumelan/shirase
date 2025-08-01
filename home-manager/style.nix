{
  lib,
  config,
  pkgs,
  user,
  ...
}:
let
  cfg = config.custom.stylix;
  logo = ../hosts/logo.png;
  changeColor =
    with config.lib.stylix.colors;
    image:
    pkgs.runCommand "themed-logo.png" { } ''
      ${lib.getExe pkgs.lutgen} apply -o $out ${image} -- \
      ${base00} ${base01} ${base02} ${base03} ${base04} ${base05} \
      ${base06} ${base07} ${base08} ${base09} ${base0A} ${base0B} \
      ${base0C} ${base0D} ${base0E} ${base0F}
    '';
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
      icons = {
        package = lib.mkOption {
          type = lib.types.package;
          default = pkgs.papirus-icon-theme;
        };
        light = lib.mkOption {
          type = lib.types.str;
          default = "Papirus-Light";
        };
        dark = lib.mkOption {
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
        size = 32; # available cursor size: 24, 32, 48, 64, 96 and 128
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

    home.file = {
      ".themed-logo.png".source = changeColor logo;
      ".profile.jpg".source = ../users/${user}.jpg;
    };
  };
}
