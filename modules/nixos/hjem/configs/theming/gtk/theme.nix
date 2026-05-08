{
  self,
  lib,
  ...
}: let
  inherit (lib) mkOption;
  inherit (lib.types) package str;
in {
  perSystem = {pkgs, ...}: {
    packages = {
      colloid-gtk-theme = pkgs.colloid-gtk-theme.override {
        themeVariants = ["pink"];
        colorVariants = ["dark"];
        sizeVariants = ["compact"];
        tweaks = ["catppuccin"];
      };
      catppuccin-papirus-folders = pkgs.catppuccin-papirus-folders.override {
        flavor = "frappe";
        accent = "maroon";
      };
    };
  };

  flake.modules.nixos.gtk = {
    config,
    pkgs,
    ...
  }: let
    inherit (self.packages.${pkgs.stdenv.hostPlatform.system}) colloid-gtk-theme catppuccin-papirus-folders;
  in {
    options.custom = {
      gtk = {
        theme = {
          package = mkOption {
            type = package;
            default = colloid-gtk-theme;
            description = "Package providing the theme.";
          };

          name = mkOption {
            type = str;
            default = "Colloid-Pink-Dark-Compact-Catppuccin";
            description = "The name of the theme within the package.";
          };
        };

        iconTheme = {
          package = mkOption {
            type = package;
            default = catppuccin-papirus-folders;
            description = "Package providing the icon theme.";
          };

          name = mkOption {
            type = str;
            default = "Papirus-Dark";
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
