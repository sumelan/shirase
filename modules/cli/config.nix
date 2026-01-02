_: {
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
    custom.fonts.packages = [
      pkgs.noto-fonts
      pkgs.noto-fonts-color-emoji
      pkgs.maple-mono.NF-unhinted
    ];
  };
}
