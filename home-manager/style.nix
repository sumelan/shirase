{ pkgs, ...}: {
  stylix = {
    targets = {
      fish.enable = false;
      waybar.enable = false;
      rofi.enable = false;
    };
    iconTheme = {
      enable = true;
      package = pkgs.papirus-icon-theme.override {color = "black";};
      light = "Papirus-Light";
      dark = "Papirus-Dark";
    };
  };
}

