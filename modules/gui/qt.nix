{lib, ...}: let
  inherit (lib.generators) toINI;
in {
  flake.modules.nixos.gui = {
    config,
    pkgs,
    ...
  }: {
    environment = {
      sessionVariables = {
        QT_QPA_PLATFORMTHEME = "qt5ct";
        QT_STYLE_OVERRIDE = "kvantum";
      };

      systemPackages = with pkgs; [
        qt6Packages.qt6ct
        qt6Packages.qtstyleplugin-kvantum
        qt6Packages.qtwayland
      ];
    };

    # use gtk theme on qt apps
    qt = {
      enable = true;
      platformTheme = "qt5ct";
      style = "kvantum";
    };

    hm = {
      xdg.configFile = let
        qtConf = {
          Appearance = {
            icon_theme = config.custom.gtk.iconTheme.name;
            style = "kvantum";
          };
        };
      in {
        "qt5ct/qt5ct.conf".text = toINI {} qtConf;
        "qt6ct/qt6ct.conf".text = toINI {} qtConf;
        "Kvantum/Nordic".source = "${pkgs.nordic}/share/Kvantum/Nordic";
        "Kvantum/kvantum.kvconfig".text = toINI {} {
          General.theme = "Nordic";
        };
      };
    };
  };
}
