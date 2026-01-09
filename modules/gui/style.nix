{lib, ...}: let
  inherit (lib.generators) toINI;
in {
  flake.modules.homeManager.default = {
    config,
    pkgs,
    ...
  }: {
    home.pointerCursor = {
      package = pkgs.capitaine-cursors-themed;
      name = "Capitaine Cursors (Nord)";
      size = 38;
      gtk.enable = true;
      x11.enable = true;
    };

    dconf.settings = {
      # disable dconf first use warning
      "ca/desrt/dconf-editor" = {
        show-warning = false;
      };
      # set dark theme for gtk 4
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        cursor-theme = config.home.pointerCursor.name;
      };
    };

    gtk = {
      enable = true;
      theme = {
        package = pkgs.colloid-gtk-theme.override {
          themeVariants = ["pink"]; # default: blue
          colorVariants = ["dark"]; # default: all
          sizeVariants = ["compact"]; # default: standard
          tweaks = ["nord"];
        };
        name = "Colloid-Pink-Dark-Compact-Nord";
      };
      iconTheme = {
        package = pkgs.colloid-icon-theme.override {
          schemeVariants = ["nord"];
          colorVariants = ["pink"]; # default is blue
        };
        name = "Colloid-Pink-Nord-Dark";
      };
      font = {
        name = config.custom.fonts.regular;
        package = pkgs.montserrat;
        size = 14;
      };
      gtk2 = {
        configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
        force = true; # plasma seems to override this file?
      };
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
        gtk-error-bell = 0;
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
        gtk-error-bell = 0;
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "qtct";
      style.name = "kvantum";
    };

    home = {
      sessionVariables = {
        XCURSOR_SIZE = builtins.div config.home.pointerCursor.size 2;
      };

      packages = [
        pkgs.libsForQt5.qt5ct
        pkgs.libsForQt5.qtstyleplugin-kvantum
        pkgs.libsForQt5.qtwayland
        pkgs.qt6Packages.qt6ct
        pkgs.qt6Packages.qtstyleplugin-kvantum
        pkgs.qt6Packages.qtwayland
      ];
    };

    xdg.configFile = {
      kvantum = {
        target = "Kvantum/kvantum.kvconfig";
        text = toINI {} {
          General.theme = "Nordic";
        };
      };

      # Kvantum looks for themes here
      Kvantum-Nordic = {
        target = "Kvantum/Nordic";
        source = "${pkgs.nordic}/share/Kvantum/Nordic";
        recursive = true;
      };

      qt5ct = {
        target = "qt5ct/qt5ct.conf";
        text = toINI {} {
          Appearance = {
            custom_palette = false;
            icon_theme = config.gtk.iconTheme.name;
            style = "kvantum";
          };
        };
      };

      qt6ct = {
        target = "qt6ct/qt6ct.conf";
        text = toINI {} {
          Appearance = {
            custom_palette = false;
            icon_theme = config.gtk.iconTheme.name;
            style = "kvantum";
          };
        };
      };
    };
  };
}
