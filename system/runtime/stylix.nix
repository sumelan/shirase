{
  pkgs,
  isLaptop,
  ...
}:
let
  colors = "catppuccin-mocha";
in
{
  stylix = {
    enable = true;
    image = pkgs.fetchurl {
      url = "https://github.com/NixOS/nixos-artwork/blob/33856d7837cb8ba76c4fc9e26f91a659066ee31f/wallpapers/nixos-wallpaper-catppuccin-mocha.png";
        sha256 = "VIrSOBCCNq6Fc0dS7XMtC1VebnjRvIUi0/kPal2gWcU=";
    };
    base16Scheme = "${pkgs.base16-schemes}/share/themes/${colors}.yaml";
    polarity = "dark";
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Original-Ice";
      size = 24;
    };
    fonts = {
      monospace = {
        package = pkgs.maple-mono-NF;
        name = "Maple Mono NF";
      };
      sansSerif = {
        package = pkgs.nerd-fonts.ubuntu;
        name = "Ubuntu Nerd Font";
      };
      serif = {
        package = pkgs.nerd-fonts.ubuntu;
        name = "Ubuntu Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        applications = 12;
        terminal = 13;
        desktop = 12;
        popups = if isLaptop then 9 else 12;
      };
    };
    opacity = {
      applications = 0.95;
      terminal = 0.95;
      desktop = 0.95;
      popups = 0.75;
    };
    targets.fish.enable = false;
  };
}
