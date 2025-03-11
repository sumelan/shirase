{
  pkgs,
  isLaptop,
  ...
}:
{
  stylix = {
    enable = true;
    autoEnable = false;

    targets = {
      gtk = {
        enable = true;
        flatpakSupport.enable = true;
      };
      qt = {
        enable = true;
      };
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 20;
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
        popups = if isLaptop then 10 else 14;
      };
    };

    iconTheme = {
      enable = true;
      package = pkgs.zafiro-icons;
      dark = "Zafiro-icons-Dark";
      light = "Zafiro-icons-Light";
    };
  };

  # home font package used without stylix
  home.packages = [
    # waybar and hyprlock
    pkgs.nerd-fonts.comic-shanns-mono
    pkgs.maple-mono-NF
  ];
}
