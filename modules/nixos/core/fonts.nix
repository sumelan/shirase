{lib, ...}: let
  inherit (lib) mkOption;
  inherit (lib.types) str listOf package;
in {
  flake.modules.nixos.default = {
    config,
    pkgs,
    ...
  }: {
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
      # setup fonts
      fonts = {
        enableDefaultPackages = true;
        inherit (config.custom.fonts) packages;
      };

      custom.fonts.packages = [
        pkgs.noto-fonts
        pkgs.noto-fonts-cjk-sans
        pkgs.noto-fonts-color-emoji
        pkgs.maple-mono.NF-unhinted # [info] unhinted font: for high resolution screen
      ];
    };
  };
}
