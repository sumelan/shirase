{lib, ...}: let
  inherit (lib) mkOption;
  inherit (lib.types) package str;
in {
  perSystem = {pkgs, ...}: {
    packages = {
      colloid-gtk-theme = pkgs.pkgs.colloid-gtk-theme.override {
        themeVariants = ["grey"]; # default: blue
        colorVariants = ["dark"]; # default: all
        sizeVariants = ["compact"]; # default: standard
        tweaks = ["nord"];
      };
      papirus-nord = pkgs.papirus-nord.override {
        accent = "polarnight3";
      };
    };
  };

  flake.modules.nixos = {
    gui = {pkgs, ...}: {
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
              default = "Colloid-Grey-Dark-Compact-Nord";
              description = "The name of the theme within the package.";
            };
          };

          iconTheme = {
            package = mkOption {
              type = package;
              default = pkgs.custom.papirus-nord;
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
    };

    hjem-gui = {config, ...}: {
      hj.packages = [
        config.custom.gtk.theme.package
        config.custom.gtk.iconTheme.package
      ];
    };
  };
}
