{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  options.custom = with lib; {
    stylix = {
      colorTheme = mkOption {
        type = types.str;
        default = "catppuccin-mocha";
      };
    };
  };

  config = {
    stylix = {
      enable = true;
      autoEnable = false;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/${config.custom.stylix.colorTheme}.yaml";

      targets = {
        console.enable = true;
        gnome.enable = true;
        plymouth.enable = true;
        chromium.enable = true;
      };
    };
  };
}
