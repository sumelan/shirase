{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.custom = with lib; {
    stylix = {
      colorTheme = mkOption {
        type = types.str;
        default = "catppuccin-mocha";
      };
      polarity = mkOption {
        type = types.str;
        default = "dark";
      };
    };
  };

  config = {
    stylix = {
      enable = true;
      autoEnable = false;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/${config.custom.stylix.colorTheme}.yaml";
      polarity = config.custom.stylix.polarity;

      targets = {
        console.enable = true;
        gnome.enable = true;
        plymouth.enable = true;
        chromium.enable = true;
      };
    };
  };
}
