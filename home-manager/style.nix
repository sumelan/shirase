{ pkgs, isLaptop, ... }:
{
  stylix = {
    enable = true;
    autoEnable = false;

    targets = {
      gtk = {
        enable = true;
        flatpakSupport.enable = true;
      };
      qt.enable = true;
      gnome.enable = true;
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Original-Amber";
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
        popups = if isLaptop then 10 else 12;
      };
    };

    iconTheme = {
      enable = true;
      package = pkgs.qogir-icon-theme;
      light = "Qogir-Ubuntu-Light";
      dark = "Qogir-Ubuntu-Dark";
    };

    opacity = {
      desktop = 0.95;
      popups = 0.85;
      terminal = 1.0;
    };
  };

  # other font packages
  home.packages = with pkgs; [
    # japanese
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    # other nerd fonts
    maple-mono.NF
  ];
}
