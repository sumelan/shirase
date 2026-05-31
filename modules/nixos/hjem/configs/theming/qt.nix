{lib, ...}: {
  flake.custom.hjemConfigs.qt = {
    config,
    pkgs,
    ...
  }: {
    # use gtk theme on qt apps
    qt = {
      enable = true;
      platformTheme = "qt5ct";
      style = "kvantum";
    };

    hj = {
      environment.sessionVariables = {
        QT_QPA_PLATFORMTHEME = "qt5ct";
        QT_STYLE_OVERRIDE = "kvantum";
      };

      packages = [
        pkgs.kdePackages.qt6ct
        pkgs.kdePackages.qtstyleplugin-kvantum
        pkgs.kdePackages.qtwayland
      ];

      xdg.config.files = let
        qtConf = {
          Appearance = {
            icon_theme = config.custom.gtk.iconTheme.name;
            style = "kvantum";
          };
        };
      in {
        "Kvantum/Nordic".source = "${pkgs.nordic}/share/Kvantum/Nordic";
        "Kvantum/kvantum.kvconfig" = {
          generator = lib.generators.toINI {};
          value = {
            General.theme = "Nordic";
          };
        };

        "kdeglobals".text = ''
          [UiSettings]
          ColorScheme=Nordic
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
