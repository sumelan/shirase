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
        popups = if isLaptop then 11 else 12;
      };
    };

    iconTheme = {
      enable = true;
      package = pkgs.reversal-icon-theme;
      dark = "Reversal";
      light = "Reversal-dark";
    };
  };

  # other non-default font package
  home.packages = with pkgs; [
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    # waybar and hyprlock
    maple-mono.NF
  ];
}
