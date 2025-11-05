{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkOption;
  inherit
    (lib.types)
    package
    str
    listOf
    ;
in {
  options.custom = {
    fonts = {
      regular = mkOption {
        type = str;
        default = "Geist";
        description = "The font to use for regular text";
      };
      monospace = mkOption {
        type = str;
        default = "Maple Mono NF";
        description = "The font to use for monospace text";
      };
      packages = mkOption {
        type = listOf package;
        description = "The packages to install for the fonts";
      };
    };
  };

  config = {
    custom = {
      fonts.packages = builtins.attrValues {
        inherit
          (pkgs)
          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-color-emoji
          ;
        monopkgs = pkgs.maple-mono.NF;
      };
    };
  };
}
