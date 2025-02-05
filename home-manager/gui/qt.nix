# make qt use a dark theme, adapted from:
# https://github.com/fufexan/dotfiles/blob/main/home/programs/qt.nix
# also see:
# https://discourse.nixos.org/t/struggling-to-configure-gtk-qt-theme-on-laptop/42268/
{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.custom = with lib; {
    qtStyleFix = mkEnableOption "fix styling for qt applications" // {
      default = true;
    };
  };

  config = lib.mkIf (config.custom.qtStyleFix) {
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
      # Kvantum looks for themes here
      "Kvantum" = {
        source = "${pkgs.catppuccin-kvantum.src}/themes";
        recursive = true;
      };
    };
  };
}
