{pkgs, ...}: {
  # Japanese settings
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [fcitx5-mozc];
    fcitx5.waylandFrontend = true;
  };

  home.packages = with pkgs; [
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];
}
