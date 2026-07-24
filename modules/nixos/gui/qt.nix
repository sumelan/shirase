{lib, ...}: {
  flake.modules.nixos.gui = {
    config,
    pkgs,
    user,
    ...
  }: {
    # use gtk theme on qt apps
    qt = {
      enable = true;
      platformTheme = "qt5ct";
      style = "kvantum";
    };

    environment = {
      sessionVariables = {
        QT_QPA_PLATFORMTHEME = "qt5ct";
        QT_STYLE_OVERRIDE = "kvantum";
      };

      systemPackages = [
        pkgs.kdePackages.qt6ct
        pkgs.kdePackages.qtstyleplugin-kvantum
        pkgs.kdePackages.qtwayland
      ];
    };

    hjem.users.${user} = {
      xdg.config.files = let
        qtConf = {
          Appearance = {
            icon_theme = config.custom.gtk.iconTheme.name;
            style = "kvantum";
          };
        };
      in {
        "Kvantum/catppuccin-frappe-blue".source = "${pkgs.catppuccin-kvantum}/share/Kvantum/catppuccin-frappe-blue";
        "Kvantum/kvantum.kvconfig" = {
          generator = lib.generators.toINI {};
          value = {
            General.theme = "catppuccin-frappe-blue";
          };
        };

        "kdeglobals".text = ''
          [UiSettings]
          ColorScheme=catppuccin-frappe-blue
        '';

        "qt5ct/qt5ct.conf" = {
          generator = lib.generators.toINI {};
          value = qtConf;
        };
        "qt6ct/qt6ct.conf" = {
          generator = lib.generators.toINI {};
          value = qtConf;
        };
      };
    };
  };
}
