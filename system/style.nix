{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.custom = with lib; {
    stylix = {
      theme = mkOption {
        type = types.str;
        default = "catppuccin-mocha";
      };
    };
  };

  config = {
    stylix = {
      enable = true;
      autoEnable = false;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/${config.custom.stylix.theme}.yaml";
      polarity = "dark";

      targets = {
        console.enable = true;
        gnome.enable = true;
        plymouth.enable = true;
        chromium.enable = true;
      };
    };

    # install cjk fonts on system-wide
    fonts.packages = with pkgs; [
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
    ];
  };
}


