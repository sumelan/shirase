{ pkgs, ...}: {
  stylix = {
    iconTheme = {
      enable = true;
      package = pkgs.papirus-icon-theme.override {color = "black";};
      light = "Papirus-Light";
      dark = "Papirus-Dark";
    };
  };
}

