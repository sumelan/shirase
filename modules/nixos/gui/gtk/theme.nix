{
  config,
  pkgs,
  ...
}: let
  inherit (pkgs.lib) mkOption;
  inherit (pkgs.lib.types) package str;
in {
  options.custom = {
    gtk = {
      theme = {
        package = mkOption {
          type = package;
          default = pkgs.adw-gtk3;
          description = "Package providing the theme.";
        };

        name = mkOption {
          type = str;
          default = "adw-gtk3-dark";
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
}
