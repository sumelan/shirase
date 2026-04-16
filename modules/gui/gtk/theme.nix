{lib, ...}: let
  inherit (lib) mkOption;
  inherit (lib.types) package str;
in {
  perSystem = {pkgs, ...}: {
    packages = {
      colloid-gtk-theme = pkgs.colloid-gtk-theme.override {
        themeVariants = ["pink"];
        colorVariants = ["dark"];
        sizeVariants = ["compact"];
        tweaks = ["everforest"];
      };
      colloid-icon-theme = pkgs.colloid-icon-theme.override {
        schemeVariants = ["everforest"];
        colorVariants = ["pink"];
      };
    };
  };

  flake.modules.nixos.gui = {
    config,
    pkgs,
    ...
  }: {
    options.custom = {
      gtk = {
        theme = {
          package = mkOption {
            type = package;
            default = pkgs.custom.colloid-gtk-theme;
            description = "Package providing the theme.";
          };

          name = mkOption {
            type = str;
            default = "Colloid-Pink-Dark-Compact-Everforest";
            description = "The name of the theme within the package.";
          };
        };

        iconTheme = {
          package = mkOption {
            type = package;
            default = pkgs.custom.colloid-icon-theme;
            description = "Package providing the icon theme.";
          };

          name = mkOption {
            type = str;
            default = "Colloid-Pink-Everforest-Dark";
            description = "The name of the icon theme within the package.";
          };
        };
      };
    };

    config = {
      hj.packages = [
        config.custom.gtk.theme.package
        config.custom.gtk.iconTheme.package
      ];
    };
  };
}
