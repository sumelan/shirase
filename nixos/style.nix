{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkOption
    ;
  inherit (lib.types) str;
in {
  options.custom = {
    stylix = {
      colorTheme = mkOption {
        type = str;
        default = "gruvbox-material-dark-soft";
      };
    };
  };

  config = {
    stylix = {
      enable = true;
      autoEnable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/${config.custom.stylix.colorTheme}.yaml";

      fonts = {
        sansSerif = {
          package = pkgs.geist-font;
          name = "Geist";
        };
        serif = config.stylix.fonts.sansSerif;
        monospace = {
          package = pkgs.maple-mono.NF; # Maple Mono NF (Ligature hinted)
          name = "Maple Mono NF";
        };
        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
      };
    };
  };
}
