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
        QT_QPA_PLATFORM = "wayland";
        QT_QPA_PLATFORMTHEME = "qt5ct";
        QT_QPA_PLATFORMTHEME_QT6 = "qt6ct";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
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
        catppuccin-kvantum = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "Kvantum";
          rev = "71105d224fef95dd023691303477ce3eea487457";
          hash = "sha256-gcvCVZjVbj5fRZWaM+mZTwH/g158MH36JmMuMgCBuqQ=";
        };

        qtConf = {
          Appearance = {
            icon_theme = config.custom.gtk.iconTheme.name;
            style = "kvantum";
          };
        };
      in {
        "Kvantum/Catppuccin-Frappe-Pink".source = "${catppuccin-kvantum}/themes/catppuccin-frappe-pink";
        "Kvantum/kvantum.kvconfig" = {
          generator = lib.generators.toINI {};
          value = {
            General.theme = "Catppuccin-Frappe-Pink";
          };
        };

        "kdeglobals".text = ''
          [UiSettings]
          ColorScheme=Catppuccin-Frappe-Pink
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
