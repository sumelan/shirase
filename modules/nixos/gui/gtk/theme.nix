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
            default = pkgs.whitesur-gtk-theme.override {
              altVariants = ["normal"]; # default: normal
              colorVariants = ["dark"]; # default: all
              opacityVariants = ["solid"]; # default: all
              themeVariants = ["pink"]; # default: default (BigSur-like theme)
              schemeVariants = ["standard"]; # default: standard
              iconVariant = "simple"; # default: standard (Apple logo)
              nautilusStyle = "stable"; # default: stable (BigSur-like style)
              panelOpacity = "default"; # default: 15%
              panelSize = "smaller"; # default: 32px
              roundedMaxWindow = false; # default: false
              darkerColor = false; # default = false
            };

            description = "Package providing the theme.";
          };

          name = mkOption {
            type = str;
            default = "Whitesur-Dark-solid-alt-pink";
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
