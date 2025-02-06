{ pkgs, ...}:
{
  stylix = {
    targets = {
      fish.enable = false;
      rofi.enable = false;
      waybar.enable = false;
    };
    iconTheme = {
      enable = true;
      package = pkgs.papirus-icon-theme.override {color = "black";};
      light = "Papirus-Light";
      dark = "Papirus-Dark";
    };
  };

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    font-awesome
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    material-icons
  ];

}
