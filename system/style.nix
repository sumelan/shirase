{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  inherit
    (lib)
    mkOption
    types
    ;
in {
  imports = [inputs.stylix.nixosModules.stylix];

  options.custom = with types; {
    stylix = {
      colorTheme = mkOption {
        type = str;
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
