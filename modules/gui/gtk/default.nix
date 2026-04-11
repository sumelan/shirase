{lib, ...}: let
  inherit (lib) mkOption literalExpression isBool boolToString escape mkMerge concatMapStringsSep;
  inherit (lib.types) attrs listOf str package number;
  inherit (lib.generators) toINI;
  inherit (lib.gvariant) mkUint32;
in {
  flake.modules.nixos.gui = {
    config,
    pkgs,
    user,
    ...
  }: let
    gtkCfg = config.custom.gtk;
    toIni = toINI {
      mkKeyValue = key: value: let
        value' =
          if isBool value
          then boolToString value
          else toString value;
      in "${escape ["="] key}=${value'}";
    };
    gtkIni = toIni {
      Settings = {
        gtk-theme-name = gtkCfg.theme.name;
        gtk-icon-theme-name = gtkCfg.iconTheme.name;
        gtk-font-name = "${gtkCfg.font.name} 14";
        gtk-application-prefer-dark-theme = 1;
        gtk-error-bell = 0;
      };
    };
  in {
    options.custom = {
      # type referenced from nixpkgs:
      # https://github.com/NixOS/nixpkgs/blob/554be6495561ff07b6c724047bdd7e0716aa7b46/nixos/modules/programs/dconf.nix#L121C9-L134C1
      dconf.settings = mkOption {
        type = attrs;
        default = {};
        description = "An attrset used to generate dconf keyfile.";
        example = literalExpression ''
          with lib.gvariant;
          {
            "com/raggesilver/BlackBox" = {
              scrollback-lines = mkUint32 10000;
              theme-dark = "Tommorrow Night";
            };
          }
        '';
      };
      gtk = {
        bookmarks = mkOption {
          type = listOf str;
          default = [];
          example = ["/home/jane/Documents"];
          description = "File browser bookmarks.";
        };

        font = {
          package = mkOption {
            type = package;
            default = pkgs.montserrat;
            description = "Package providing font";
          };

          name = mkOption {
            type = str;
            default = config.custom.fonts.regular;
            description = "The family name of the font within the package.";
          };

          size = mkOption {
            type = number;
            default = 14;
            description = "The size of the font.";
          };
        };
      };
    };

    config = {
      environment = {
        etc = {
          "xdg/gtk-3.0/settings.ini".text = gtkIni;
          "xdg/gtk-4.0/settings.ini".text = gtkIni;
          "xdg/gtk-2.0/gtkrc".text = ''
            gtk-font-name = "${gtkCfg.font.name} 14";
            gtk-icon-theme-name = "${gtkCfg.iconTheme.name}";
            gtk-theme-name = "${gtkCfg.theme.name}";
          '';
        };

        sessionVariables = {
          GTK2_RC_FILES = "/etc/xdg/gtk-2.0/gtkrc";
        };
      };

      fonts.packages = [
        gtkCfg.font.package
      ];

      programs.dconf = {
        enable = true;
        profiles.${user}.databases = [
          {
            settings = mkMerge [
              {
                # disable dconf first use warning
                "ca/desrt/dconf-editor" = {
                  show-warning = false;
                };
                # gtk related settings
                "org/gnome/desktop/interface" = {
                  color-scheme = "prefer-dark"; # set dark theme for gtk 4
                  cursor-theme = gtkCfg.cursor.name;
                  cursor-size = mkUint32 gtkCfg.cursor.size;
                  font-name = "${gtkCfg.font.name} 14";
                  gtk-theme = gtkCfg.theme.name;
                  icon-theme = gtkCfg.iconTheme.name;
                  # disable middle click paste
                  gtk-enable-primary-paste = false;
                };
              }
              config.custom.dconf.settings
            ];
          }
        ];
      };

      hj.xdg.config.files."gtk-3.0/bookmarks".text =
        concatMapStringsSep "\n" (
          b: "file://${b}"
        )
        gtkCfg.bookmarks;
    };
  };
}
