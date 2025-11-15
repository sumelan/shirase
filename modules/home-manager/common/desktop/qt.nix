# make qt use a dark theme, adapted from:
# https://github.com/fufexan/dotfiles/blob/main/home/programs/qt.nix
# also see:
# https://discourse.nixos.org/t/struggling-to-configure-gtk-qt-theme-on-laptop/42268/
{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib.generators) toINI;
in {
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
}
