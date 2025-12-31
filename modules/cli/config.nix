{lib, ...}: {
  flake.modules.homeManager.default = {pkgs, ...}: {
    home.packages = builtins.attrValues {
      inherit
        (pkgs)
        brightnessctl
        cliphist
        libnotify
        playerctl
        wl-clipboard
        ;
    };
    custom.fonts.packages = builtins.attrValues {
      inherit
        (pkgs)
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        ;
      monopkgs = pkgs.maple-mono.NF-unhinted;
    };
  };
}
