_: let
  inherit (builtins) attrValues;
in {
  flake.modules.homeManager.default = {pkgs, ...}: {
    home.packages = attrValues {
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
    ];
  };
}
