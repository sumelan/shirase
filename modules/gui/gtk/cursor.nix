{lib, ...}: let
  inherit (lib) mkOption;
  inherit (lib.types) package str int;
in {
  flake.modules.nixos.gui = {
    config,
    pkgs,
    ...
  }: let
    # Add cursor icon link to $XDG_DATA_HOME/icons as well for redundancy.
    gtkCursor = config.custom.gtk.cursor;
  in {
    options.custom = {
      gtk = {
        cursor = {
          package = mkOption {
            type = package;
            default = pkgs.capitaine-cursors-themed;
            description = "Package providing the cursor theme.";
          };

          name = mkOption {
            type = str;
            default = "Capitaine Cursors (Nord)";
            description = "The cursor name within the package.";
          };

          size = mkOption {
            type = int;
            default = 40;
            description = "The cursor size.";
          };
        };
      };
    };

    config = {
      environment.sessionVariables = {
        XCURSOR_SIZE = gtkCursor.size;
        XCURSOR_THEME = gtkCursor.name;
      };

      hj = {
        packages = [
          gtkCursor.package
        ];
        xdg.data.files."icons/${gtkCursor.name}" = {
          source = "${gtkCursor.package}/share/icons/${gtkCursor.name}";
        };
      };
    };
  };
}
