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
      autoEnable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/${config.custom.stylix.colorTheme}.yaml";
    };
  };
}
