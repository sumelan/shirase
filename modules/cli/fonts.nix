{lib, ...}: let
  inherit (lib) mkOption;
  inherit
    (lib.types)
    str
    listOf
    package
    ;
in {
  flake.modules.nixos.default = {pkgs, ...}: {
    options.custom = {
      fonts = {
        regular = mkOption {
          type = str;
          default = "Montserrat";
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
      custom.fonts.packages = [
        pkgs.noto-fonts
        pkgs.noto-fonts-color-emoji
      ];
    };
  };
}
