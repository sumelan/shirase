{
  pkgs,
  isLaptop,
  ...
}:
{
  stylix = {
    enable = true;
    autoEnable = false;
    targets.gtk.enable = true;
    targets.gtk.flatpakSupport.enable = true;
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };

    fonts = {
      sansSerif = {
        package = pkgs.nerd-fonts.ubuntu;
        name = "Ubuntu Nerd Font";
      };
      serif = {
        package = pkgs.nerd-fonts.ubuntu;
        name = "Ubuntu Nerd Font";
      };
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        applications = 12;
        terminal = 11;
        desktop = 12;
        popups = if isLaptop then 9 else 14;
      };
    };
    iconTheme = {
      enable = true;
      package = pkgs.papirus-icon-theme.override { color = "black"; };
      light = "Papirus-Light";
      dark = "Papirus-Dark";
    };
  };

  # user font package used without stylix
  home.packages = [
    # waybar
    pkgs.nerd-fonts.comic-shanns-mono
    # pkgs.maple-mono-NF
  ];
}
