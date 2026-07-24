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
            default = pkgs.fluent-gtk-theme.override {
              themeVariants = ["pink"]; # default: blue
              colorVariants = ["dark"]; # default: all
              sizeVariants = ["compact"]; # default: standard
              tweaks = ["blur"];
            };
            description = "Package providing the theme.";
          };

          name = mkOption {
            type = str;
            default = "Fluent-pink-Dark-compact";
            description = "The name of the theme within the package.";
          };
        };

        iconTheme = {
          package = mkOption {
            type = package;
            default = pkgs.fluent-icon-theme.override {
              roundedIcons = false;
              blackPanelIcons = false;
              allColorVariants = false;
              colorVariants = ["pink"];
            };
            description = "Package providing the icon theme.";
          };

          name = mkOption {
            type = str;
            default = "Fluent-pink-dark";
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
