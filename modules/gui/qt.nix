{lib, ...}: let
  inherit (lib.generators) toINI;
in {
  flake.modules.nixos.gui = {
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
        pkgs.qt6Packages.qt6ct
        pkgs.qt6Packages.qtstyleplugin-kvantum
        pkgs.qt6Packages.qtwayland
      ];

      xdg.config.files = let
        qtConf = {
          Appearance = {
            icon_theme = config.custom.gtk.iconTheme.name;
            style = "kvantum";
          };
        };
        everforest = pkgs.fetchFromGitHub {
          owner = "binEpilo";
          repo = "materia-everforest-kvantum";
          rev = "391eb1d917dab900dc1ef16ffdff1a4546308ee4";
          hash = "sha256-5ihKScPJMDU0pbeYtUx/UjC4J08/r40mAK7D+1TK6wA=";
        };
      in {
        "Kvantum/MaterialEverforest".source = "${everforest}/MateriaEverforestDark";
        "Kvantum/kvantum.kvconfig" = {
          generator = toINI {};
          value = {
            General.theme = "MaterialEverforest";
          };
        };
        "qt5ct/qt5ct.conf" = {
          generator = toINI {};
          value = qtConf;
        };
        "qt6ct/qt6ct.conf" = {
          generator = toINI {};
          value = qtConf;
        };
      };
    };
  };
}
