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
    ;
  inherit (lib.types) str;
in {
  imports = [inputs.stylix.nixosModules.stylix];

  options.custom = {
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
