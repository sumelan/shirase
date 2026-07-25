{lib, ...}: let
  inherit (lib) mkOption;
  inherit (lib.types) package str;
in {
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
            default = pkgs.colloid-gtk-theme.override {
              themeVariants = ["pink"]; # default: blue
              colorVariants = ["dark"]; # default: all
              sizeVariants = ["compact"]; # default: standard
              tweaks = ["catppuccin"];
            };
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
            default = pkgs.catppuccin-papirus-folders.override {
              flavor = "frappe";
              accent = "pink";
            };
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
      environment.systemPackages = [
        config.custom.gtk.theme.package
        config.custom.gtk.iconTheme.package
      ];
    };
  };
}
