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
    };
  };
}
