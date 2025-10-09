{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkOption
    ;

  inherit
    (lib.types)
    package
    str
    ;
  cfg = config.custom.stylix;
in {
  options.custom = {
    stylix = {
      cursor = {
        package = mkOption {
          type = package;
          default = pkgs.capitaine-cursors-themed;
        };
        name = mkOption {
          type = str;
          default = "Capitaine Cursors (Gruvbox)";
        };
      };
      icons = {
        package = mkOption {
          type = package;
          default = pkgs.gruvbox-plus-icons.override {
            # Supported colors:
            # black blue caramel citron firebrick gold green grey highland jade lavender lime olive
            # orange pistachio plasma pumpkin purple red rust sapphire tomato violet white yellow
            folder-color = "yellow";
          };
        };
        light = mkOption {
          type = str;
          default = "";
        };
        dark = mkOption {
          type = str;
          default = "Gruvbox-Plus-Dark";
        };
      };
    };
  };

  config = {
    stylix = {
      enable = true;
      autoEnable = true;
      polarity = "dark";
      # unnecessary module
      targets = {
        kde.enable = false;
        blender.enable = false;
        forge.enable = false;
      };
      cursor = {
        inherit (cfg.cursor) package name;
      };
      icons = {
        enable = true;
        inherit (cfg.icons) package light dark;
      };
      opacity = {
        desktop = 0.95;
        popups = 0.85;
        terminal = 1.0;
      };
    };
  };
}
