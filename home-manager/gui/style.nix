{ pkgs, ...}: {
  stylix = {
    targets = {
      fish.enable = false;
      kitty.enable = false;
      waybar.enable = false;
      rofi.enable = false;
      spicetify.enable = false;
    };
    iconTheme = {
      enable = true;
      package = pkgs.papirus-icon-theme.override {color = "black";};
      light = "Papirus-Light";
      dark = "Papirus-Dark";
    };
  };
}

