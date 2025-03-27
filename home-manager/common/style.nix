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
        popups = if isLaptop then 11 else 14;
      };
    };

    iconTheme = {
      enable = true;
      package = pkgs.fluent-icon-theme;
      dark = "Fluent-dark";
      light = "Fluent-light";
    };
  };

  # home font package used without stylix
  home.packages = [
    # waybar and hyprlock
    pkgs.nerd-fonts.aurulent-sans-mono
    pkgs.maple-mono-NF
  ];
}
