# make qt use a dark theme, adapted from:
# https://github.com/fufexan/dotfiles/blob/main/home/programs/qt.nix
# also see:
# https://discourse.nixos.org/t/struggling-to-configure-gtk-qt-theme-on-laptop/42268/
{
  lib,
  pkgs,
  config,
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

    packages = with pkgs; [
      libsForQt5.qt5ct
      libsForQt5.qtstyleplugin-kvantum
      libsForQt5.qtwayland
      qt6Packages.qt6ct
      qt6Packages.qtstyleplugin-kvantum
      qt6Packages.qtwayland
    ];
  };

  xdg.configFile = {
    kvantum = {
      target = "Kvantum/kvantum.kvconfig";
      text = toINI {} {
        General.theme = "Kvantum-Tokyo-Night";
      };
    };

    # Kvantum looks for themes here
    Kvantum-Tokyo-Night = {
      target = "Kvantum/Kvantum-Tokyo-Night";
      source = "${pkgs.custom.tokyo-night-kvantum}/share/Kvantum/Kvantum-Tokyo-Night";
      recursive = true;
    };

    qt5ct = {
      target = "qt5ct/qt5ct.conf";
      text = toINI {} {
        Appearance = {
          custom_palette = false;
          icon_theme = "Papirus-Dark";
          style = "kvantum";
        };
      };
    };

    qt6ct = {
      target = "qt6ct/qt6ct.conf";
      text = toINI {} {
        Appearance = {
          custom_palette = false;
          icon_theme = "Papirus-Dark";
          style = "kvantum";
        };
      };
    };
  };
}
